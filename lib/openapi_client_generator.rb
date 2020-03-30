# frozen_string_literal: true

require 'json'
require 'pathname'
require 'active_support/inflector'
require 'oas_parser'
require 'redcarpet'
require 'redcarpet/render_strip'
require 'rubocop'
require 'pry'

module OpenAPIClientGenerator

  class Endpoint
    class PositionalParameterizer
      def parameterize(args)
        args.empty? ? "options = {}" : "#{args.join(", ")}, options = {}"
      end
    end

    class KwargsParameterizer
      def parameterize(args)
        args.empty? ? "**options" : "#{args.map {|arg| arg + ":"}.join(", ")}, **options"
      end
    end

    VERB_PRIORITY = %w(GET POST PUT PATCH DELETE)

    attr_reader :definition, :parameterizer
    def initialize(oas_endpoint, overrides, parameterizer: OpenAPIClientGenerator::Endpoint::PositionalParameterizer)
      @definition    = oas_endpoint
      @overrides     = overrides
      @parameterizer = parameterizer.new
    end

    def to_s
      [
        tomdoc,
        method_definition,
        alias_definitions,
        enum_definitions
      ].compact.join("\n")
    end

    def tomdoc
      <<-TOMDOC.chomp
      # #{method_summary}
      #
      # #{parameter_documentation.join("\n      # ")}
      # @return #{return_type_description} #{return_value_description}
      # @see #{definition.raw["externalDocs"]["url"]}
      TOMDOC
    end

    def method_summary
      resource = namespace.split("_").last
      org_summary = definition.summary.gsub("#{resource}", "org #{resource}").gsub("a org", "an org")
      (definition.operation_id.split("/").first == "orgs") ? org_summary : definition.summary
    end

    def method_definition
      <<-DEF.chomp
      def #{method_name}(#{parameters})
        #{method_implementation}
      end
      DEF
    end

    def enum_definitions
      result = []
      if definition.request_body && definition.request_body.content["application/json"]
        definition.request_body.properties_for_format("application/json").each do |param|
          if param.enum && param.enum.size < 3 && param.default.nil?
            param.enum.each do |enum|
              enum_action = enum.delete_suffix("d").gsub("open", "reopen")
              parameter_docs = parameter_documentation.reject { |p| p.include? param.name }
              first_word = definition.summary.split(" ").first
              enum_summary = definition.summary.gsub(first_word, enum_action.capitalize)
              result << %Q(
      # #{enum_summary}
      #
      # #{parameter_docs.join("\n     # ")}
      def #{enum_action.downcase}_#{namespace}(#{parameters})
        options[:#{param.name}] = "#{enum}"
        #{method_implementation}
      end)
            end
          end
        end
      end

      if result.any?
        result.join("\n")
      end
    end

    def alias_definitions
      if namespace.include? "or_"
        namespace_array = definition.operation_id.split(/-|\//)
        index = namespace_array.index("or")
        %Q(
      alias #{namespace_array[index-1]}_#{namespace_array.last} #{method_name}
      alias #{namespace_array[index+1]}_#{namespace_array.last} #{method_name}
        )
      end
    end

    def method_implementation
      if @overrides.include? method_name
        @overrides[method_name]
      else
        [
          *option_overrides,
          api_call,
        ].reject(&:empty?).join("\n        ")
      end
    end

    def option_overrides
      options = ["opts = options.dup"]
      if definition.request_body && definition.request_body.content["application/json"]
        params = definition.request_body.properties_for_format("application/json").select do |param|
          param.schema['required'].include? param.name if param.schema['required']
        end.map do |param|
          normalization = ""
          if !!param.enum
            normalization = ".to_s.downcase"
          end
          if param.description.include? "Base64"
            options << "opts[:#{param.name}] = Base64.strict_encode64(#{param.name})"
          else
            options << "opts[:#{param.name}] = #{param.name}#{normalization}"
          end
          if param.raw["required"] && param.raw["required"] != true
            options << "raise Octokit::MissingKey.new unless #{param.name}.key? :#{param.raw["required"].first}"
          end
        end
      end
      if definition.raw["x-github"]["previews"].any? {|e| e["required"]}
        preview_types = definition.raw["x-github"]["previews"].select {|e| e["required"]}
        accept_header = "\"application/vnd.github.#{preview_types.first["name"]}-preview+json\""
        options << "opts[:accept] = #{accept_header} if opts[:accept].nil?\n"
      end
      options.size > 1 ? options : []
    end

    def boolean_response?
      return true if definition.raw["responses"].key? "204" or definition.raw["responses"].key? "205"
      return true if definition.raw["responses"].key? "201" and definition.raw["responses"]["201"].keys.count == 1
      false
    end

    def api_call
      option_format = option_overrides.any? ? "opts" : "options"
      if boolean_response?
        "boolean_from_response :#{definition.method}, \"#{api_path}\", #{option_format}"
      elsif !singular?
        "paginate \"#{api_path}\", #{option_format}"
      else
        "#{definition.method} \"#{api_path}\", #{option_format}"
      end
    end

    def api_path
      map = {"repos/{owner}/{repo}" => "\#{Repository.path repo}",
             "orgs/{org}" => "\#{Organization.path org}",
             "users/{username}" => "\#{User.path user}",
             "{gist_id}" => "\#{Gist.new gist_id}" }

      re = Regexp.new(map.keys.map { |x| Regexp.escape(x) }.join('|'))
      path = definition.path.path[1..-1].gsub(re, map)
      path = required_params.reduce(path) do |path, param|
        path.gsub("{#{param.name}}", "\#{#{param.name}}")
      end
    end

    def return_type_description
      if verb == "GET" && !singular?
        "[Array<Sawyer::Resource>]"
      elsif boolean_response?
        "[Boolean]"
      else
        "[Sawyer::Resource]"
      end
    end

    def required_params
      params = definition.parameters.select(&:required).reject do |param|
        param.in == "header" or param.name == "owner"
      end

      if params.first && params.first.name == "username"
        params.first.raw["name"] = "user"
        params[0] = OasParser::Parameter.new(params.first.owner, params.first.raw)
      end

      if definition.request_body && definition.request_body.content["application/json"]
        params += definition.request_body.properties_for_format("application/json").select do |param|
          param.schema['required'].include? param.name if param.schema['required']
        end
      end

      if definition.request_body && definition.request_body.content["*/*"]
        definition.request_body.content["*/*"]["schema"]["name"] = "data"
        params += [OasParser::Parameter.new(params.first.owner, definition.request_body.content["*/*"]["schema"])]
      end
      params
    end

    def optional_params
      params = definition.parameters.reject(&:required).reject do |param|
        ["accept", "per_page", "page"].include?(param.name)
      end
      if definition.request_body && definition.request_body.content["application/json"]
        params += definition.request_body.properties_for_format("application/json").reject do |param|
          param.schema['required'].include? param.name if param.schema['required']
        end
      end
      params
    end

    def parameter_type(param)
      {
        "repo" => "[Integer, String, Repository, Hash]",
        "org" => "[Integer, String]",
        "user" => "[Integer, String]",
        "gist_id" => "[Integer, String]",
      }[param.name] || "[#{param.type.capitalize}]"
    end

    def parameter_description(param)
      return "A GitHub repository" if param.name == "repo"
      return "A GitHub organization id or login" if param.name == "org"
      return "A GitHub user id or login" if param.name == "user"
      return "The ID of the #{param.name.gsub("_id", "").gsub("_", " ")}" if param.name.end_with? "_id"
      split_param =  param.name.split("_")
      split_description = param.description.split(" ")
      resource = split_param.size > 1 ? split_param.first : namespace.split("_").last
      resource = (namespace.split("_").size == 3)? namespace.split("_").first : resource
      return "The #{split_param.last} of the #{resource}" if split_description.last == "parameter"
      return collapse_lists(param).gsub("\n", "")
    end

    def collapse_lists(param)
      md = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
      description = md.render(param.description)
      split_description = description.split("*")
      list = split_description.drop(1).map { |line| line.split(":")[0] }
      (split_description[0] + list.join(","))
    end

    def parameter_documentation
      required_params.map {|param|
        "@param #{param.name} #{parameter_type(param)} #{parameter_description(param)}"
      } + optional_params.map {|param|
        "@option options [#{param.type.capitalize}] :#{param.name} #{parameter_description(param).gsub("\n", "")}"
      }
    end

    def return_value_description
      if verb == "GET"
        if namespace.include?("latest")
          "The latest #{namespace.split("_").last}"
        elsif !singular?
          "A list of #{namespace.split("_").last.pluralize}"
        else
          resource = (namespace.include? "by")? namespace.split("_").first : namespace.split("_").last
          "A single #{resource}"
        end
      elsif boolean_response?
        "True on success, false otherwise"
      elsif verb == "POST"
        case namespace
        # Note: hardcoded check
        when "issue_assignees"
          "The updated #{definition.tags.first.singularize}"
        else
          "The new #{namespace.split("_").last.singularize}"
        end
      elsif verb == "PATCH"
        "The updated #{namespace.split("_").last}"
      else
        if definition.responses && definition.responses.first.content && definition.responses.first.content["application/json"]["schema"]["type"] == "array"
          "An array of the remaining #{namespace.split("_").last}"
        else
          "The updated #{definition.operation_id.split("/").first.singularize}"
        end
      end
    end

    def verb
      definition.method.upcase
    end

    def parameters
      params = required_params.map do |p|
        (p.raw["required"].present? && p.raw["required"] != true) ? "#{p.name} = {}" : p.name
      end
      parameterizer.parameterize(params)
    end

    def singular?
      return true unless definition.parameters.any? {|p| p.name == "per_page"}
      false
    end

    def namespace
      operation_array = definition.operation_id.split("/")
      namespace_array = operation_array.last.split("-")

      div_words = %w(for on about)
      if (div_words & namespace_array).any?
        words = namespace_array.select {|w| div_words.include? w}
        index = namespace_array.index(words.first)

        if words.first == "for" && index > 1 && operation_array.first != "activity"
          resource = namespace_array[index+1..-1].join("_").gsub("repo", operation_array[0])
        else
          resource = namespace_array[index+1..-1].join("_").gsub("repo", "repository")
        end

        return resource if words.first == "about"

        first_half = namespace_array[0..index-1]
        subresource = (first_half.size == 1) ? operation_array.first : first_half.drop(1).join("_")
        subresource = "#{subresource}_#{operation_array.first}" if subresource == "public"
        subresource = singular? ? subresource.singularize : subresource

        "#{resource}_#{subresource}"
      elsif namespace_array.size == 1
        singular? ? operation_array.first.singularize : operation_array.first
      elsif namespace_array.size == 2
        resource = namespace_array.last
        return resource if ["repos", "activity"].include? operation_array.first

        if namespace_array.last.end_with?("ed") or resource == "public"
          return "#{resource}_#{operation_array.first}"
        end

        "#{operation_array.first.singularize}_#{resource}"
      elsif namespace_array.first == "check"
        "#{operation_array.first.singularize}_#{namespace_array.last}"
      else
        namespace_array.drop(1).join("_")
      end
    end

    def action
      definition.operation_id.split("/").last.split("-").first
    end

    def method_name
      case verb
      when "GET"
        (definition.operation_id.split("/").last.include? "check") ? "#{namespace}?" : namespace
      when "POST", "PATCH", "DELETE", "PUT"
        "#{action}_#{namespace}"
      else
      end
    end

    def parts
      definition.path.path.split("/").reject { |segment| segment.include? "id" }
    end

    def resource_priority
      definition.tags.include?("repos")? 0 : 1
    end

    def priority
      [resource_priority, parts.count, VERB_PRIORITY.index(verb), singular?? 0 : 1]
    end
  end

  class API
    def self.at(definition, parameterizer: OpenAPIClientGenerator::Endpoint::PositionalParameterizer)
      overrides_path = "lib/openapi/overrides.rb"
      source = RuboCop::ProcessedSource.new(File.read(overrides_path), 2.7, overrides_path)

      # child_nodes[0] is args, child_node[1] is body
      method_overrides = { source.ast.children.first.to_s => source.ast.child_nodes[1].source }

      grouped_paths = definition.paths.group_by do |oas_path|
        resource_for_path(oas_path.path)
      end
      grouped_paths.delete(:unsupported)
      grouped_paths.each do |resource, paths|
        endpoints = paths.each_with_object([]) do |path, arr|
          path.endpoints.each do |endpoint|
            arr << OpenAPIClientGenerator::Endpoint.new(endpoint, method_overrides, parameterizer: parameterizer)
          end
        end
        yield new(resource, endpoints: endpoints)
      end
    end

    def self.resource_for_path(path)
      path_segments = path.split("/").reject{ |segment| segment == "" }

      supported_resources = %w(deployments pages hooks releases labels milestones issues reactions projects gists events checks contents downloads readme pulls notifications)
      resource = case path_segments.first
                 when "orgs", "users"
                   path_segments[2]
                 when "repos"
                   path_segments[3]
                 else
                   path_segments[0]
                 end
      resource = resource.split("-").first.pluralize unless (resource.nil? or resource == "readme")
      return (supported_resources.include? resource) ? resource : :unsupported
    end

    attr_reader :resource, :endpoints
    def initialize(resource, endpoints: [])
      @resource = resource
      @endpoints = endpoints
    end

    def documentation_url
      endpoints.first.definition.raw["externalDocs"]["url"].gsub(/#.*/, "")
    end

    def to_s
      <<-FILE
# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the #{resource.capitalize} API
    #
    # @see #{documentation_url}
    module #{resource.capitalize}

#{endpoints.sort_by(&:priority).join("\n\n")}
    end
  end
end
      FILE
    end
  end
end

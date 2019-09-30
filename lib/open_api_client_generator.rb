require 'forwardable'
require 'json'
require 'pathname'
require 'active_support/inflector'
require 'oas_parser'

module OpenAPIClientGenerator

  class Endpoint
    class PositionalParameterizer
      def parameterize(args)
        "#{args.join(", ")}, options = {}"
      end
    end

    class KwargsParameterizer
      def parameterize(args)
        "#{args.map {|arg| arg + ":"}.join(", ")}, **options"
      end
    end

    extend Forwardable

    VERB_PRIORITY = %w(GET POST)

    delegate [:documentation_url] => :definition

    attr_reader :definition, :parameterizer
    def initialize(oas_endpoint, parameterizer: OpenAPIClientGenerator::Endpoint::PositionalParameterizer)
      @definition    = oas_endpoint
      @parameterizer = parameterizer.new
    end

    def to_s
      [
        tomdoc,
        method_definition,
        alias_definition,
      ].compact.join("\n")
    end

    def tomdoc
      <<-TOMDOC.chomp
      # #{definition.summary}
      #
      # #{parameter_documentation.join("\n      # ")}
      # @return #{return_type_description} #{return_value_description}
      # @see #{definition.raw["externalDocs"]["url"]}
      TOMDOC
    end

    def method_definition
      <<-DEF.chomp
      def #{method_name}(#{parameters})
        #{method_implementation}
      end
      DEF
    end

    def alias_definition
      return unless alternate_name
      "      alias :#{alternate_name} :#{method_name}"
    end

    def singular?
      definition.path.path.split("/").last.include? "id"
    end

    def method_implementation
      [
        *option_overrides,
        api_call,
      ].reject(&:empty?).join("\n        ")
    end

    def option_overrides
      required_params.reject do |param|
        param.name == "repo" || param.name.include?("id")
      end.map do |param|
        normalization = ""
        if !!param.enum
          normalization = ".to_s.downcase"
        end
        "options[:#{param.name}] = #{param.name}#{normalization}"
      end
    end

    def api_call
      "#{definition.method}(\"#{api_path}\", options)"
    end

    def api_path
      path = definition.path.path.gsub("/repos/{owner}/{repo}", "\#{Repository.path repo}")
      path = required_params.reduce(path) do |path, param|
        path.gsub("{#{param.name}}", "\#{#{param.name}}")
      end
    end

    def return_type_description
      if verb == "GET" && !singular?
        "[Array<Sawyer::Resource>]"
      else
        "<Sawyer::Resource>"
      end
    end

    def required_params
      params = definition.parameters.select(&:required).reject {|param| ["owner", "accept"].include?(param.name)}
      if definition.request_body
        params += definition.request_body.properties_for_format("application/json").select { |param| definition.request_body.content["application/json"]["schema"]["required"].include? param.name }
      end
      params
    end

    def optional_params
      params = definition.parameters.reject(&:required).reject {|param| ["accept", "per_page", "page"].include?(param.name)}
      if definition.request_body
        params += definition.request_body.properties_for_format("application/json").reject { |param| definition.request_body.content["application/json"]["schema"]["required"].include? param.name }
      end
      params
    end

    def parameter_type(param)
      {
        "repo" => "[Integer, String, Repository, Hash]",
      }[param.name] || "[#{param.type.capitalize}]"
    end

    def parameter_description(param)
      return "A GitHub repository" if param.name == "repo"
      return "The ID of the #{param.name.gsub("_id", "").gsub("_", " ")}" if param.name.end_with? "_id"
      return param.description.gsub("\n", "") unless param.description.empty?

      "The ID of the #{param.name.gsub("_id", "").gsub("_", " ")}" if name.end_with?("_id")
    end

    def parameter_documentation
      required_params.map {|param|
        "@param #{param.name} #{parameter_type(param)} #{parameter_description(param)}"
      } + optional_params.map {|param|
        "@param options [#{param.type.capitalize}] :#{param.name} #{param.description.gsub("\n", "")}"
      }
    end

    def return_value_description
      case verb
      when "GET"
        if singular?
          "A single #{namespace.gsub("_", " ")}"
        else
          "A list of #{namespace.gsub("_", " ")}"
        end
      when "POST"
        "The new #{namespace.singularize.gsub("_", " ")}"
      else
      end
    end

    def verb
      definition.method.upcase
    end

    def parameters
      parameterizer.parameterize(required_params.map(&:name))
    end

    def namespace
      definition.operation_id.split("/").last.split("-").drop(1).join("_")
    end

    def method_name
      case verb
      when "GET"
        namespace
      when "POST"
        "create_#{namespace}"
      else
      end
    end

    def alternate_name
      return unless verb == "GET"
      return if singular?
      "list_#{namespace}"
    end

    def parts
      definition.path.path.split("/").reject { |segment| segment.include? "id" }
    end

    def priority
      [parts.count, VERB_PRIORITY.index(verb), singular?? 0 : 1]
    end
  end

  class API
    def self.at(definition, parameterizer: OpenAPIClientGenerator::Endpoint::PositionalParameterizer)
      # just for this spike
      paths = definition.paths.select { |oas_path| oas_path.path.include? "deployment" }
      endpoints = paths.each_with_object([]) do |path, a|
        path.endpoints.each do |endpoint|
          a << OpenAPIClientGenerator::Endpoint.new(endpoint, parameterizer: parameterizer)
        end
      end
      new("deployments", endpoints: endpoints)
    end

    attr_reader :path, :endpoints
    def initialize(path, endpoints: [])
      @path      = path
      @endpoints = endpoints
    end

    def namespace
      Pathname.new(path).basename.to_s.capitalize
    end

    def documentation_url
      endpoints.first.definition.raw["externalDocs"]["url"].gsub(/#.*/, "")
    end

    def to_s
      <<-FILE
module Octokit
  class Client
    # Methods for the #{namespace} API
    #
    # @see #{documentation_url}
    module #{namespace}

#{endpoints.sort_by(&:priority).join("\n\n")}
    end
  end
end
      FILE
    end
  end
end

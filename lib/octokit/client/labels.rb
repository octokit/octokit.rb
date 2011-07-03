module Octokit
  class Client
    module Labels

      # List available labels for a repository
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @return [Array] A list of the labels currently on the issue
      # @see http://developer.github.com/v3/issues/labels/
      # @example List labels for pengwynn/octokit
      #   Octokit.labels("pengwynn/octokit")
      def labels(repo, options={})
        get("repos/#{Repository.new(repo)}/labels", options, 3)
      end

      # Get single label for a repository
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param name [String] Name of the label
      # @return [Label] A single label from the repository
      # @see http://developer.github.com/v3/issues/labels/#get-a-single-label
      # @example Get the "V3 Addition" label from pengwynn/octokit
      #   Octokit.labels("pengwynn/octokit")
      def label(repo, name, options={})
        get("repos/#{Repository.new(repo)}/labels/#{URI.encode_www_form_component(name)}", options, 3)
      end

      # Add a label to a repository
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param label [String] A new label
      # @param color [String] A color, in hex, without the leading #
      # @return [Label] A Hashie of the new label
      # @see http://developer.github.com/v3/issues/labels/
      # @example Add a new label "Version 1.0" with color "#cccccc"
      #   Octokit.add_label("pengwynn/octokit", "Version 1.0", "cccccc")
      def add_label(repo, label, color="ffffff", options={})
        post("repos/#{Repository.new(repo)}/labels", options.merge({:name => label, :color => color}), 3)
      end

      # Remove a label from a repository
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param id [String] String name of the label
      # @return [Response] A Faraday Response object
      # @see http://developer.github.com/v3/issues/labels/#delete-a-label
      # @see http://rubydoc.info/gems/faraday/0.5.3/Faraday/Response
      # @example Remove the label "Version 1.0" from the repository
      #   Octokit.remove_label("pengwynn/octokit", "Version 1.0")
      def remove_label(repo, label, options={})
        delete("repos/#{Repository.new(repo)}/labels/#{URI.encode_www_form_component(label)}", options, 3, true, true)
      end

    end
  end
end

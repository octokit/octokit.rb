module Octokit
  class Client
    module Labels

      # List available labels for a repository
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @return [Array] A list of the labels across the repository
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

      # Update a label 
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param label [String] The name of the label which will be updated
      # @param options [Hash] A customizable set of options.
      # @option options [String] :title An updated label name
      # @option options [String] :color An updated color value, in hex, without leading #
      # @return [Label] A Hashie of the updated label
      # @see http://developer.github.com/v3/issues/labels/#update-a-label
      # @example Update the label "Version 1.0" with new color "#cceeaa"
      #   Octokit.update_label("pengwynn/octokit", "Version 1.0", {:color => "cceeaa"})
      def update_label(repo, label, options={})
        post("repos/#{Repository.new(repo)}/labels/#{URI.encode_www_form_component(label)}", options, 3)
      end

      # Delete a label from a repository.  
      #
      # This deletes the label from the repository, and removes it from all issues.
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param label [String] String name of the label
      # @return [Response] A Faraday Response object
      # @see http://developer.github.com/v3/issues/labels/#delete-a-label
      # @see http://rubydoc.info/gems/faraday/0.5.3/Faraday/Response
      # @example Delete the label "Version 1.0" from the repository.
      #   Octokit.delete_label!("pengwynn/octokit", "Version 1.0")
      def delete_label!(repo, label, options={})
        delete("repos/#{Repository.new(repo)}/labels/#{URI.encode_www_form_component(label)}", options, 3, true, true)
      end

      def remove_label(repo, number, label, options={})
        delete("repos/#{Repository.new(repo)}/issues/#{number}/labels/#{URI.encode_www_form_component(label)}", options, 3, true)
      end

      # List available for a given issue
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param number [String] Number ID of the issue
      # @return [Array] A list of the labels currently on the issue
      # @see http://developer.github.com/v3/issues/labels/
      # @example List labels for pengwynn/octokit
      #   Octokit.labels("pengwynn/octokit")
      def labels_for_issue(repo, number, options={})
        get("repos/#{Repository.new(repo)}/issues/#{number}/labels", options, 3)
      end

      # Add label(s) to an Issue
      #
      # @param repository [String, Repository, Hash] A Github repository
      # @param number [String] Number ID of the issue
      # @param labels [Array] An array of labels to apply to this Issue
      # @return [Array] A list of the labels currently on the issue
      # @see http://developer.github.com/v3/issues/labels/#add-labels-to-an-issue
      # @example Add two labels for pengwynn/octokit
      #   Octokit.add_labels_to_an_issue("pengwynn/octokit", 10, ['V3 Transition', 'Improvement'])
      def add_labels_to_an_issue(repo, number, labels)
        post("repos/#{Repository.new(repo)}/issues/#{number}/labels", labels, 3)
      end
    end
  end
end

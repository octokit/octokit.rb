require 'cgi'

module Octokit
  class Client
    module Labels

      # List available labels for a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @return [Array] A list of the labels across the repository
      # @see http://developer.github.com/v3/issues/labels/
      # @example List labels for pengwynn/octokit
      #   Octokit.labels("pengwynn/octokit")
      def labels(repo, options={})
        get("repos/#{Repository.new(repo)}/labels", options)
      end

      # Get single label for a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param name [String] Name of the label
      # @return [Label] A single label from the repository
      # @see http://developer.github.com/v3/issues/labels/#get-a-single-label
      # @example Get the "V3 Addition" label from pengwynn/octokit
      #   Octokit.labels("pengwynn/octokit")
      def label(repo, name, options={})
        get("repos/#{Repository.new(repo)}/labels/#{CGI.escape(name)}", options)
      end

      # Add a label to a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param label [String] A new label
      # @param color [String] A color, in hex, without the leading #
      # @return [Label] A Hashie of the new label
      # @see http://developer.github.com/v3/issues/labels/
      # @example Add a new label "Version 1.0" with color "#cccccc"
      #   Octokit.add_label("pengwynn/octokit", "Version 1.0", "cccccc")
      def add_label(repo, label, color="ffffff", options={})
        post("repos/#{Repository.new(repo)}/labels", options.merge({:name => label, :color => color}))
      end

      # Update a label
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param label [String] The name of the label which will be updated
      # @param options [Hash] A customizable set of options.
      # @option options [String] :title An updated label name
      # @option options [String] :color An updated color value, in hex, without leading #
      # @return [Label] A Hashie of the updated label
      # @see http://developer.github.com/v3/issues/labels/#update-a-label
      # @example Update the label "Version 1.0" with new color "#cceeaa"
      #   Octokit.update_label("pengwynn/octokit", "Version 1.0", {:color => "cceeaa"})
      def update_label(repo, label, options={})
        post("repos/#{Repository.new(repo)}/labels/#{CGI.escape(label)}", options)
      end

      # Delete a label from a repository.
      #
      # This deletes the label from the repository, and removes it from all issues.
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param label [String] String name of the label
      # @return [Boolean] Success
      # @see http://developer.github.com/v3/issues/labels/#delete-a-label
      # @see http://rubydoc.info/gems/faraday/0.5.3/Faraday/Response
      # @example Delete the label "Version 1.0" from the repository.
      #   Octokit.delete_label!("pengwynn/octokit", "Version 1.0")
      def delete_label!(repo, label, options={})
        boolean_from_response(:delete, "repos/#{Repository.new(repo)}/labels/#{CGI.escape(label)}", options)
      end

      # Remove a label from an Issue
      #
      # This removes the label from the Issue
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [String] Number ID of the issue
      # @param label [String] String name of the label
      # @return [Array] A list of the labels currently on the issue
      # @see http://rubydoc.info/gems/faraday/0.5.3/Faraday/Response
      # @see http://developer.github.com/v3/issues/labels/#remove-a-label-from-an-issue
      # @example Remove the label "Version 1.0" from the repository.
      #   Octokit.remove_label("pengwynn/octokit", 23, "Version 1.0")
      def remove_label(repo, number, label, options={})
        delete("repos/#{Repository.new(repo)}/issues/#{number}/labels/#{CGI.escape(label)}", options)
      end

      # Remove all label from an Issue
      #
      # This removes the label from the Issue
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [String] Number ID of the issue
      # @return [Boolean] Success of operation
      # @see http://developer.github.com/v3/issues/labels/#remove-all-labels-from-an-issue
      # @example Remove all labels from Issue #23
      #   Octokit.remove_all_labels("pengwynn/octokit", 23)
      def remove_all_labels(repo, number, options={})
        boolean_from_response(:delete, "repos/#{Repository.new(repo)}/issues/#{number}/labels", options)
      end

      # List labels for a given issue
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [String] Number ID of the issue
      # @return [Array] A list of the labels currently on the issue
      # @see http://developer.github.com/v3/issues/labels/#list-labels-on-an-issue
      # @example List labels for pengwynn/octokit
      #   Octokit.labels("pengwynn/octokit")
      def labels_for_issue(repo, number, options={})
        get("repos/#{Repository.new(repo)}/issues/#{number}/labels", options)
      end

      # Add label(s) to an Issue
      #
      # @param repo [String, Repository, Hash] A Github repository
      # @param number [String] Number ID of the issue
      # @param labels [Array] An array of labels to apply to this Issue
      # @return [Array] A list of the labels currently on the issue
      # @see http://developer.github.com/v3/issues/labels/#add-labels-to-an-issue
      # @example Add two labels for pengwynn/octokit
      #   Octokit.add_labels_to_an_issue("pengwynn/octokit", 10, ['V3 Transition', 'Improvement'])
      def add_labels_to_an_issue(repo, number, labels)
        post("repos/#{Repository.new(repo)}/issues/#{number}/labels", labels)
      end

      # Replace all labels on an Issue
      #
      # @param repo [String, Repository, Hash] A Github repository
      # @param number [String] Number ID of the issue
      # @param labels [Array] An array of labels to use as replacement
      # @return [Array] A list of the labels currently on the issue
      # @see http://developer.github.com/v3/issues/labels/#replace-all-labels-for-an-issue
      # @example Replace labels for pengwynn/octokit Issue #10
      #   Octokit.replace_all_labels("pengwynn/octokit", 10, ['V3 Transition', 'Improvement'])
      def replace_all_labels(repo, number, labels, options={})
        put("repos/#{Repository.new(repo)}/issues/#{number}/labels", labels)
      end

      # Get labels for every issue in a milestone
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [String] Number ID of the milestone
      # @return [Array] A list of the labels across the milestone
      # @see  http://developer.github.com/v3/issues/labels/#get-labels-for-every-issue-in-a-milestone
      # @example List all labels for milestone #2 on pengwynn/octokit
      #   Octokit.labels_for_milestone("pengwynn/octokit", 2)
      def labels_for_milestone(repo, number, options={})
        get("repos/#{Repository.new(repo)}/milestones/#{number}/labels", options)
      end

    end
  end
end

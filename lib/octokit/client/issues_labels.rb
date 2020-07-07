# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the IssuesLabels API
    #
    # @see https://developer.github.com/v3/issues/labels/
    module IssuesLabels
      # List labels for a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of labels
      # @see https://developer.github.com/v3/issues/labels/#list-labels-for-a-repository
      def issues_labels(repo, options = {})
        paginate "#{Repository.path repo}/labels", options
      end

      # Create a label
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param name [String] The name of the label. Emoji can be added to label names, using either native emoji or colon-style markup. For example, typing :strawberry: will render the emoji :strawberry: https://github.githubassets.com/images/icons/emoji/unicode/1f353.png. For a full list of available emoji and codes, see emoji-cheat-sheet.com (http://emoji-cheat-sheet.com/).
      # @param color [String] The hexadecimal color code (http://www.color-hex.com/) for the label, without the leading #.
      # @option options [String] :description A short description of the label.
      # @return [Sawyer::Resource] The new label
      # @see https://developer.github.com/v3/issues/labels/#create-a-label
      def create_issue_label(repo, name, color, options = {})
        opts = options.dup
        opts[:name] = name
        opts[:color] = color
        post "#{Repository.path repo}/labels", opts
      end

      # Get a label
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param name [String] The name of the label
      # @return [Sawyer::Resource] A single label
      # @see https://developer.github.com/v3/issues/labels/#get-a-label
      def issue_label(repo, name, options = {})
        get "#{Repository.path repo}/labels/#{name}", options
      end

      # Update a label
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param name [String] The name of the label
      # @option options [String] :new_name The new name of the label. Emoji can be added to label names, using either native emoji or colon-style markup. For example, typing :strawberry: will render the emoji :strawberry: https://github.githubassets.com/images/icons/emoji/unicode/1f353.png. For a full list of available emoji and codes, see emoji-cheat-sheet.com (http://emoji-cheat-sheet.com/).
      # @option options [String] :color The hexadecimal color code (http://www.color-hex.com/) for the label, without the leading #.
      # @option options [String] :description A short description of the label.
      # @return [Sawyer::Resource] The updated label
      # @see https://developer.github.com/v3/issues/labels/#update-a-label
      def update_issue_label(repo, name, options = {})
        patch "#{Repository.path repo}/labels/#{name}", options
      end

      # Delete a label
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param name [String] The name of the label
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/issues/labels/#delete-a-label
      def delete_issue_label(repo, name, options = {})
        boolean_from_response :delete, "#{Repository.path repo}/labels/#{name}", options
      end

      # List labels for issues in a milestone
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param milestone_number [Integer] The number of the milestone
      # @return [Array<Sawyer::Resource>] A list of labels
      # @see https://developer.github.com/v3/issues/labels/#list-labels-for-issues-in-a-milestone
      def milestone_labels(repo, milestone_number, options = {})
        paginate "#{Repository.path repo}/milestones/#{milestone_number}/labels", options
      end

      # List labels for an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @return [Array<Sawyer::Resource>] A list of labels
      # @see https://developer.github.com/v3/issues/labels/#list-labels-for-an-issue
      def issue_labels(repo, issue_number, options = {})
        paginate "#{Repository.path repo}/issues/#{issue_number}/labels", options
      end

      # Add labels to an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @param labels [Array] The name of the label to add to the issue. Must contain at least one label. Note: Alternatively, you can pass a single label as a string or an array of labels directly, but GitHub recommends passing an object with the labels key.
      # @return [Sawyer::Resource] The list of new labels
      # @see https://developer.github.com/v3/issues/labels/#add-labels-to-an-issue
      def add_issue_labels(repo, issue_number, labels, options = {})
        opts = options.dup
        opts[:labels] = labels
        post "#{Repository.path repo}/issues/#{issue_number}/labels", opts
      end

      # Set labels for an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @option options [Array] :labels The names of the labels to add to the issue. You can pass an empty array to remove all labels. Note: Alternatively, you can pass a single label as a string or an array of labels directly, but GitHub recommends passing an object with the labels key.
      # @return [Sawyer::Resource] An array of the remaining labels
      # @see https://developer.github.com/v3/issues/labels/#set-labels-for-an-issue
      def set_issue_labels(repo, issue_number, options = {})
        put "#{Repository.path repo}/issues/#{issue_number}/labels", options
      end

      # Remove all labels from an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/issues/labels/#remove-all-labels-from-an-issue
      def remove_all_labels(repo, issue_number, options = {})
        boolean_from_response :delete, "#{Repository.path repo}/issues/#{issue_number}/labels", options
      end

      # Remove a label from an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @param name [String] The name of the label
      # @return [Sawyer::Resource] An array of the remaining label
      # @see https://developer.github.com/v3/issues/labels/#remove-a-label-from-an-issue
      def remove_issue_label(repo, issue_number, name, options = {})
        delete "#{Repository.path repo}/issues/#{issue_number}/labels/#{name}", options
      end
    end
  end
end

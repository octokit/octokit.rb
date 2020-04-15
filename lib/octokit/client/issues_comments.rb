# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the IssuesComments API
    #
    # @see https://developer.github.com/v3/issues/comments/
    module IssuesComments
      # Get a single comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @return [Sawyer::Resource] A single comment
      # @see https://developer.github.com/v3/issues/comments/#get-a-single-comment
      def issue_comment(repo, comment_id, options = {})
        get "#{Repository.path repo}/issues/comments/#{comment_id}", options
      end

      # List comments in a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [String] :sort Either created or updated.
      # @option options [String] :direction Either asc or desc. Ignored without the sort parameter.
      # @option options [String] :since Only comments updated at or after this time are returned. This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ.
      # @return [Array<Sawyer::Resource>] A list of comments
      # @see https://developer.github.com/v3/issues/comments/#list-comments-in-a-repository
      def issues_comments(repo, options = {})
        paginate "#{Repository.path repo}/issues/comments", options
      end

      # Edit a comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @param body [String] The contents of the comment.
      # @return [Sawyer::Resource] The updated comment
      # @see https://developer.github.com/v3/issues/comments/#edit-a-comment
      def update_issue_comment(repo, comment_id, body, options = {})
        opts = options.dup
        opts[:body] = body
        patch "#{Repository.path repo}/issues/comments/#{comment_id}", opts
      end

      # Delete a comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/issues/comments/#delete-a-comment
      def delete_issue_comment(repo, comment_id, options = {})
        boolean_from_response :delete, "#{Repository.path repo}/issues/comments/#{comment_id}", options
      end

      # List comments on an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @option options [String] :since Only comments updated at or after this time are returned. This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ.
      # @return [Array<Sawyer::Resource>] A list of comments
      # @see https://developer.github.com/v3/issues/comments/#list-comments-on-an-issue
      def issue_comments(repo, issue_number, options = {})
        paginate "#{Repository.path repo}/issues/#{issue_number}/comments", options
      end

      # Create a comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @param body [String] The contents of the comment.
      # @return [Sawyer::Resource] The new comment
      # @see https://developer.github.com/v3/issues/comments/#create-a-comment
      def create_issue_comment(repo, issue_number, body, options = {})
        opts = options.dup
        opts[:body] = body
        post "#{Repository.path repo}/issues/#{issue_number}/comments", opts
      end
    end
  end
end

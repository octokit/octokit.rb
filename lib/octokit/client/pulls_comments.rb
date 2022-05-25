# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the PullsComments API
    #
    # @see https://developer.github.com/v3/pulls/comments/
    module PullsComments
      # Get a review comment for a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @return [Sawyer::Resource] A single comment
      # @see https://developer.github.com/v3/pulls/comments/#get-a-review-comment-for-a-pull-request
      def review_comment(repo, comment_id, options = {})
        get "#{Repository.path repo}/pulls/comments/#{comment_id}", options
      end

      # List review comments in a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [String] :sort Can be either created or updated comments.
      # @option options [String] :direction Can be either asc or desc. Ignored without sort parameter.
      # @option options [String] :since This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ. Only returns comments updated at or after this time.
      # @return [Array<Sawyer::Resource>] A list of comments
      # @see https://developer.github.com/v3/pulls/comments/#list-review-comments-in-a-repository
      def pulls_review_comments(repo, options = {})
        paginate "#{Repository.path repo}/pulls/comments", options
      end

      # Update a review comment for a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @param body [String] The text of the reply to the review comment.
      # @return [Sawyer::Resource] The updated comment
      # @see https://developer.github.com/v3/pulls/comments/#update-a-review-comment-for-a-pull-request
      def update_review_comment(repo, comment_id, body, options = {})
        opts = options.dup
        opts[:body] = body
        patch "#{Repository.path repo}/pulls/comments/#{comment_id}", opts
      end

      # Delete a review comment for a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/pulls/comments/#delete-a-review-comment-for-a-pull-request
      def delete_review_comment(repo, comment_id, options = {})
        boolean_from_response :delete, "#{Repository.path repo}/pulls/comments/#{comment_id}", options
      end

      # List review comments on a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @option options [String] :sort Can be either created or updated comments.
      # @option options [String] :direction Can be either asc or desc. Ignored without sort parameter.
      # @option options [String] :since This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ. Only returns comments updated at or after this time.
      # @return [Array<Sawyer::Resource>] A list of comments
      # @see https://developer.github.com/v3/pulls/comments/#list-review-comments-on-a-pull-request
      def review_comments(repo, pull_number, options = {})
        paginate "#{Repository.path repo}/pulls/#{pull_number}/comments", options
      end

      # Create a review comment for a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @param body [String] The text of the review comment.
      # @param commit_id [String] The ID of the commit
      # @param path [String] The relative path to the file that necessitates a comment.
      # @option options [Integer] :position Required without comfort-fade preview. The position in the diff where you want to add a review comment. Note this value is not the same as the line number in the file. For help finding the position value, read the note above.
      # @option options [String] :side Required with comfort-fade preview. In a split diff view, the side of the diff that the pull request's changes appear on. Can be LEFT or RIGHT. Use LEFT for deletions that appear in red. Use RIGHT for additions that appear in green or unchanged lines that appear in white and are shown for context. For a multi-line comment, side represents whether the last line of the comment range is a deletion or addition. For more information, see "Diff view options (https://help.github.com/en/articles/about-comparing-branches-in-pull-requests#diff-view-options)" in the GitHub Help documentation.
      # @option options [Integer] :line Required with comfort-fade preview. The line of the blob in the pull request diff that the comment applies to. For a multi-line comment, the last line of the range that your comment applies to.
      # @option options [Integer] :start_line Required when using multi-line comments. To create multi-line comments, you must use the comfort-fade preview header. The start_line is the first line in the pull request diff that your multi-line comment applies to. To learn more about multi-line comments, see "Commenting on a pull request (https://help.github.com/en/articles/commenting-on-a-pull-request#adding-line-comments-to-a-pull-request)" in the GitHub Help documentation.
      # @option options [String] :start_side Required when using multi-line comments. To create multi-line comments, you must use the comfort-fade preview header. The start_side is the starting side of the diff that the comment applies to. Can be LEFT or RIGHT. To learn more about multi-line comments, see "Commenting on a pull request (https://help.github.com/en/articles/commenting-on-a-pull-request#adding-line-comments-to-a-pull-request)" in the GitHub Help documentation. See side in this table for additional context.
      # @return [Sawyer::Resource] The new comment
      # @see https://developer.github.com/v3/pulls/comments/#create-a-review-comment-for-a-pull-request
      def create_review_comment(repo, pull_number, body, commit_id, path, options = {})
        opts = options.dup
        opts[:body] = body
        opts[:commit_id] = commit_id
        opts[:path] = path
        post "#{Repository.path repo}/pulls/#{pull_number}/comments", opts
      end

      # Left a review comment for a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @param body [String] The text of the review comment.
      # @param commit_id [String] The ID of the commit
      # @param path [String] The relative path to the file that necessitates a comment.
      # @option options [Integer] :position Required without comfort-fade preview. The position in the diff where you want to add a review comment. Note this value is not the same as the line number in the file. For help finding the position value, read the note above.
      # @option options [Integer] :line Required with comfort-fade preview. The line of the blob in the pull request diff that the comment applies to. For a multi-line comment, the last line of the range that your comment applies to.
      # @option options [Integer] :start_line Required when using multi-line comments. To create multi-line comments, you must use the comfort-fade preview header. The start_line is the first line in the pull request diff that your multi-line comment applies to. To learn more about multi-line comments, see "Commenting on a pull request (https://help.github.com/en/articles/commenting-on-a-pull-request#adding-line-comments-to-a-pull-request)" in the GitHub Help documentation.
      def left_review_comment(repo, pull_number, body, commit_id, path, options = {})
        options[:side] = 'LEFT'
        opts = options.dup
        opts[:body] = body
        opts[:commit_id] = commit_id
        opts[:path] = path
        post "#{Repository.path repo}/pulls/#{pull_number}/comments", opts
      end

      # Right a review comment for a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @param body [String] The text of the review comment.
      # @param commit_id [String] The ID of the commit
      # @param path [String] The relative path to the file that necessitates a comment.
      # @option options [Integer] :position Required without comfort-fade preview. The position in the diff where you want to add a review comment. Note this value is not the same as the line number in the file. For help finding the position value, read the note above.
      # @option options [Integer] :line Required with comfort-fade preview. The line of the blob in the pull request diff that the comment applies to. For a multi-line comment, the last line of the range that your comment applies to.
      # @option options [Integer] :start_line Required when using multi-line comments. To create multi-line comments, you must use the comfort-fade preview header. The start_line is the first line in the pull request diff that your multi-line comment applies to. To learn more about multi-line comments, see "Commenting on a pull request (https://help.github.com/en/articles/commenting-on-a-pull-request#adding-line-comments-to-a-pull-request)" in the GitHub Help documentation.
      def right_review_comment(repo, pull_number, body, commit_id, path, options = {})
        options[:side] = 'RIGHT'
        opts = options.dup
        opts[:body] = body
        opts[:commit_id] = commit_id
        opts[:path] = path
        post "#{Repository.path repo}/pulls/#{pull_number}/comments", opts
      end

      # Create a reply for a review comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @param comment_id [Integer] The ID of the comment
      # @param body [String] The text of the review comment.
      # @return [Sawyer::Resource] The new reply
      # @see https://developer.github.com/v3/pulls/comments/#create-a-reply-for-a-review-comment
      def create_comment_reply(repo, pull_number, comment_id, body, options = {})
        opts = options.dup
        opts[:body] = body
        post "#{Repository.path repo}/pulls/#{pull_number}/comments/#{comment_id}/replies", opts
      end
    end
  end
end

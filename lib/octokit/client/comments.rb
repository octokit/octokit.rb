# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Comments API
    #
    # @see https://developer.github.com/v3/gists/comments/
    module Comments
      # Get a single commit comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @return [Sawyer::Resource] A single comment
      # @see https://developer.github.com/v3/repos/comments/#get-a-single-commit-comment
      def commit_comment(repo, comment_id, options = {})
        get "#{Repository.path repo}/comments/#{comment_id}", options
      end

      # List commit comments for a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of comments
      # @see https://developer.github.com/v3/repos/comments/#list-commit-comments-for-a-repository
      def commit_comments(repo, options = {})
        paginate "#{Repository.path repo}/comments", options
      end

      # Update a commit comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @param body [String] The contents of the comment
      # @return [Sawyer::Resource] The updated comment
      # @see https://developer.github.com/v3/repos/comments/#update-a-commit-comment
      def update_commit_comment(repo, comment_id, body, options = {})
        opts = options.dup
        opts[:body] = body
        patch "#{Repository.path repo}/comments/#{comment_id}", opts
      end

      # Delete a commit comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/repos/comments/#delete-a-commit-comment
      def delete_commit_comment(repo, comment_id, options = {})
        boolean_from_response :delete, "#{Repository.path repo}/comments/#{comment_id}", options
      end

      # List comments for a single commit
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param commit_sha [String] The sha of the commit
      # @return [Array<Sawyer::Resource>] A list of comments
      # @see https://developer.github.com/v3/repos/comments/#list-comments-for-a-single-commit
      def commit_comments(repo, commit_sha, options = {})
        paginate "#{Repository.path repo}/commits/#{commit_sha}/comments", options
      end

      # Create a commit comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param commit_sha [String] The sha of the commit
      # @param body [String] The contents of the comment.
      # @option options [String] :path Relative path of the file to comment on.
      # @option options [Integer] :position Line index in the diff to comment on.
      # @option options [Integer] :line Deprecated. Use position parameter instead. Line number in the file to comment on.
      # @return [Sawyer::Resource] The new comment
      # @see https://developer.github.com/v3/repos/comments/#create-a-commit-comment
      def create_commit_comment(repo, commit_sha, body, options = {})
        opts = options.dup
        opts[:body] = body
        post "#{Repository.path repo}/commits/#{commit_sha}/comments", opts
      end

      # Get a single comment
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @param comment_id [Integer] The ID of the comment
      # @return [Sawyer::Resource] A single comment
      # @see https://developer.github.com/v3/gists/comments/#get-a-single-comment
      def gist_comment(gist_id, comment_id, options = {})
        get "gists/#{Gist.new gist_id}/comments/#{comment_id}", options
      end

      # List comments on a gist
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @return [Array<Sawyer::Resource>] A list of comments
      # @see https://developer.github.com/v3/gists/comments/#list-comments-on-a-gist
      def gist_comments(gist_id, options = {})
        paginate "gists/#{Gist.new gist_id}/comments", options
      end

      # Create a comment
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @param body [String] The comment text.
      # @return [Sawyer::Resource] The new comment
      # @see https://developer.github.com/v3/gists/comments/#create-a-comment
      def create_gist_comment(gist_id, body, options = {})
        opts = options.dup
        opts[:body] = body
        post "gists/#{Gist.new gist_id}/comments", opts
      end

      # Edit a comment
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @param comment_id [Integer] The ID of the comment
      # @param body [String] The comment text.
      # @return [Sawyer::Resource] The updated comment
      # @see https://developer.github.com/v3/gists/comments/#edit-a-comment
      def update_gist_comment(gist_id, comment_id, body, options = {})
        opts = options.dup
        opts[:body] = body
        patch "gists/#{Gist.new gist_id}/comments/#{comment_id}", opts
      end

      # Delete a comment
      #
      # @param gist_id [Integer, String] The ID of the gist
      # @param comment_id [Integer] The ID of the comment
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/gists/comments/#delete-a-comment
      def delete_gist_comment(gist_id, comment_id, options = {})
        boolean_from_response :delete, "gists/#{Gist.new gist_id}/comments/#{comment_id}", options
      end

      # Get a single comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @return [Sawyer::Resource] A single comment
      # @see https://developer.github.com/v3/issues/comments/#get-a-single-comment
      def issue_comment(repo, comment_id, options = {})
        get "#{Repository.path repo}/issues/comments/#{comment_id}", options
      end

      # Get a single comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @return [Sawyer::Resource] A single comment
      # @see https://developer.github.com/v3/pulls/comments/#get-a-single-comment
      def pull_comment(repo, comment_id, options = {})
        get "#{Repository.path repo}/pulls/comments/#{comment_id}", options
      end

      # List comments in a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [String] :sort Can be either created or updated comments.
      # @option options [String] :direction Can be either asc or desc. Ignored without sort parameter.
      # @option options [String] :since This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ. Only returns comments updated at or after this time.
      # @return [Array<Sawyer::Resource>] A list of comments
      # @see https://developer.github.com/v3/pulls/comments/#list-comments-in-a-repository
      def pulls_comments(repo, options = {})
        paginate "#{Repository.path repo}/pulls/comments", options
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

      # Edit a comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @param body [String] The text of the reply to the review comment.
      # @return [Sawyer::Resource] The updated comment
      # @see https://developer.github.com/v3/pulls/comments/#edit-a-comment
      def update_pull_comment(repo, comment_id, body, options = {})
        opts = options.dup
        opts[:body] = body
        patch "#{Repository.path repo}/pulls/comments/#{comment_id}", opts
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

      # Delete a comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/pulls/comments/#delete-a-comment
      def delete_pull_comment(repo, comment_id, options = {})
        boolean_from_response :delete, "#{Repository.path repo}/pulls/comments/#{comment_id}", options
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

      # List comments on a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @option options [String] :sort Can be either created or updated comments.
      # @option options [String] :direction Can be either asc or desc. Ignored without sort parameter.
      # @option options [String] :since This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ. Only returns comments updated at or after this time.
      # @return [Array<Sawyer::Resource>] A list of comments
      # @see https://developer.github.com/v3/pulls/comments/#list-comments-on-a-pull-request
      def pull_comments(repo, pull_number, options = {})
        paginate "#{Repository.path repo}/pulls/#{pull_number}/comments", options
      end

      # Create a comment
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
      # @see https://developer.github.com/v3/pulls/comments/#create-a-comment
      def create_pull_comment(repo, pull_number, body, commit_id, path, options = {})
        opts = options.dup
        opts[:body] = body
        opts[:commit_id] = commit_id
        opts[:path] = path
        post "#{Repository.path repo}/pulls/#{pull_number}/comments", opts
      end

      # Left a comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @param body [String] The text of the review comment.
      # @param commit_id [String] The ID of the commit
      # @param path [String] The relative path to the file that necessitates a comment.
      # @option options [Integer] :position Required without comfort-fade preview. The position in the diff where you want to add a review comment. Note this value is not the same as the line number in the file. For help finding the position value, read the note above.
      # @option options [Integer] :line Required with comfort-fade preview. The line of the blob in the pull request diff that the comment applies to. For a multi-line comment, the last line of the range that your comment applies to.
      # @option options [Integer] :start_line Required when using multi-line comments. To create multi-line comments, you must use the comfort-fade preview header. The start_line is the first line in the pull request diff that your multi-line comment applies to. To learn more about multi-line comments, see "Commenting on a pull request (https://help.github.com/en/articles/commenting-on-a-pull-request#adding-line-comments-to-a-pull-request)" in the GitHub Help documentation.
      def left_pull_comment(repo, pull_number, body, commit_id, path, options = {})
        options[:side] = 'LEFT'
        opts = options.dup
        opts[:body] = body
        opts[:commit_id] = commit_id
        opts[:path] = path
        post "#{Repository.path repo}/pulls/#{pull_number}/comments", opts
      end

      # Right a comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @param body [String] The text of the review comment.
      # @param commit_id [String] The ID of the commit
      # @param path [String] The relative path to the file that necessitates a comment.
      # @option options [Integer] :position Required without comfort-fade preview. The position in the diff where you want to add a review comment. Note this value is not the same as the line number in the file. For help finding the position value, read the note above.
      # @option options [Integer] :line Required with comfort-fade preview. The line of the blob in the pull request diff that the comment applies to. For a multi-line comment, the last line of the range that your comment applies to.
      # @option options [Integer] :start_line Required when using multi-line comments. To create multi-line comments, you must use the comfort-fade preview header. The start_line is the first line in the pull request diff that your multi-line comment applies to. To learn more about multi-line comments, see "Commenting on a pull request (https://help.github.com/en/articles/commenting-on-a-pull-request#adding-line-comments-to-a-pull-request)" in the GitHub Help documentation.
      def right_pull_comment(repo, pull_number, body, commit_id, path, options = {})
        options[:side] = 'RIGHT'
        opts = options.dup
        opts[:body] = body
        opts[:commit_id] = commit_id
        opts[:path] = path
        post "#{Repository.path repo}/pulls/#{pull_number}/comments", opts
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

      # Create a review comment reply
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the review
      # @param comment_id [Integer] The ID of the comment
      # @param body [String] The text of the review comment.
      # @return [Sawyer::Resource] The new reply
      # @see https://developer.github.com/v3/pulls/comments/#create-a-review-comment-reply
      def create_review_comment_reply(repo, pull_number, comment_id, body, options = {})
        opts = options.dup
        opts[:body] = body
        post "#{Repository.path repo}/pulls/#{pull_number}/comments/#{comment_id}/replies", opts
      end
    end
  end
end

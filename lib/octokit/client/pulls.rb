# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Pulls API
    #
    # @see https://developer.github.com/v3/pulls/
    module Pulls
      # List pull requests
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [String] :state Either open, closed, or all to filter by state.
      # @option options [String] :head Filter pulls by head user or head organization and branch name in the format of user:ref-name or organization:ref-name. For example: github:new-script-format or octocat:test-branch.
      # @option options [String] :base Filter pulls by base branch name. Example: gh-pages.
      # @option options [String] :sort What to sort results by. Can be either created, updated, popularity (comment count) or long-running (age, filtering by pulls updated in the last month).
      # @option options [String] :direction The direction of the sort. Can be either asc or desc. Default: desc when sort is created or sort is not specified, otherwise asc.
      # @return [Array<Sawyer::Resource>] A list of pulls
      # @see https://developer.github.com/v3/pulls/#list-pull-requests
      def pulls(repo, options = {})
        paginate "#{Repository.path repo}/pulls", options
      end

      # Create a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param title [String] The title of the new pull request.
      # @param head [String] The name of the branch where your changes are implemented. For cross-repository pull requests in the same network, namespace head with a user like this: username:branch.
      # @param base [String] The name of the branch you want the changes pulled into. This should be an existing branch on the current repository. You cannot submit a pull request to one repository that requests a merge to a base of another repository.
      # @option options [String] :body The contents of the pull request.
      # @option options [Boolean] :maintainer_can_modify Indicates whether maintainers can modify (https://help.github.com/articles/allowing-changes-to-a-pull-request-branch-created-from-a-fork/) the pull request.
      # @option options [Boolean] :draft Indicates whether the pull request is a draft. See "Draft Pull Requests (https://help.github.com/en/articles/about-pull-requests#draft-pull-requests)" in the GitHub Help documentation to learn more.
      # @return [Sawyer::Resource] The new pull
      # @see https://developer.github.com/v3/pulls/#create-a-pull-request
      def create_pull(repo, title, head, base, options = {})
        opts = options.dup
        opts[:title] = title
        opts[:head] = head
        opts[:base] = base
        post "#{Repository.path repo}/pulls", opts
      end

      # Get a single pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @return [Sawyer::Resource] A single pull
      # @see https://developer.github.com/v3/pulls/#get-a-single-pull-request
      def pull(repo, pull_number, options = {})
        get "#{Repository.path repo}/pulls/#{pull_number}", options
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

      # Update a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @option options [String] :title The title of the pull request.
      # @option options [String] :body The contents of the pull request.
      # @option options [String] :state State of this Pull Request. Either open or closed.
      # @option options [String] :base The name of the branch you want your changes pulled into. This should be an existing branch on the current repository. You cannot update the base branch on a pull request to point to another repository.
      # @option options [Boolean] :maintainer_can_modify Indicates whether maintainers can modify (https://help.github.com/articles/allowing-changes-to-a-pull-request-branch-created-from-a-fork/) the pull request.
      # @return [Sawyer::Resource] The updated pull
      # @see https://developer.github.com/v3/pulls/#update-a-pull-request
      def update_pull(repo, pull_number, options = {})
        patch "#{Repository.path repo}/pulls/#{pull_number}", options
      end

      # Reopen a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @option options [String] :title The title of the pull request.
      # @option options [String] :body The contents of the pull request.
      # @option options [String] :base The name of the branch you want your changes pulled into. This should be an existing branch on the current repository. You cannot update the base branch on a pull request to point to another repository.
      # @option options [Boolean] :maintainer_can_modify Indicates whether maintainers can modify (https://help.github.com/articles/allowing-changes-to-a-pull-request-branch-created-from-a-fork/) the pull request.
      def reopen_pull(repo, pull_number, options = {})
        options[:state] = 'open'
        patch "#{Repository.path repo}/pulls/#{pull_number}", options
      end

      # Close a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @option options [String] :title The title of the pull request.
      # @option options [String] :body The contents of the pull request.
      # @option options [String] :base The name of the branch you want your changes pulled into. This should be an existing branch on the current repository. You cannot update the base branch on a pull request to point to another repository.
      # @option options [Boolean] :maintainer_can_modify Indicates whether maintainers can modify (https://help.github.com/articles/allowing-changes-to-a-pull-request-branch-created-from-a-fork/) the pull request.
      def close_pull(repo, pull_number, options = {})
        options[:state] = 'closed'
        patch "#{Repository.path repo}/pulls/#{pull_number}", options
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
      # @see https://developer.github.com/v3/pulls/comments/#delete-a-comment
      def delete_pull_comment(repo, comment_id, options = {})
        boolean_from_response :delete, "#{Repository.path repo}/pulls/comments/#{comment_id}", options
      end

      # Get a single review
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @param review_id [Integer] The ID of the review
      # @return [Sawyer::Resource] A single review
      # @see https://developer.github.com/v3/pulls/reviews/#get-a-single-review
      def pull_review(repo, pull_number, review_id, options = {})
        get "#{Repository.path repo}/pulls/#{pull_number}/reviews/#{review_id}", options
      end

      # Get if a pull request has been merged
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @return [Boolean] A single merged
      # @see https://developer.github.com/v3/pulls/#get-if-a-pull-request-has-been-merged
      def pull_merged?(repo, pull_number, options = {})
        boolean_from_response :get, "#{Repository.path repo}/pulls/#{pull_number}/merge", options
      end

      # List pull requests files
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @return [Array<Sawyer::Resource>] A list of files
      # @see https://developer.github.com/v3/pulls/#list-pull-requests-files
      def pull_files(repo, pull_number, options = {})
        paginate "#{Repository.path repo}/pulls/#{pull_number}/files", options
      end

      # List reactions for a pull request review comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @option options [String] :content Returns a single reaction type (https://developer.github.com/v3/reactions/#reaction-types). Omit this parameter to list all reactions to a pull request review comment.
      # @return [Array<Sawyer::Resource>] A list of reactions
      # @see https://developer.github.com/v3/reactions/#list-reactions-for-a-pull-request-review-comment
      def pull_request_review_comment_reactions(repo, comment_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        paginate "#{Repository.path repo}/pulls/comments/#{comment_id}/reactions", opts
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

      # List commits on a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @return [Array<Sawyer::Resource>] A list of commits
      # @see https://developer.github.com/v3/pulls/#list-commits-on-a-pull-request
      def pull_commits(repo, pull_number, options = {})
        paginate "#{Repository.path repo}/pulls/#{pull_number}/commits", options
      end

      # List review requests
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @return [Array<Sawyer::Resource>] A list of requests
      # @see https://developer.github.com/v3/pulls/review_requests/#list-review-requests
      def review_requests(repo, pull_number, options = {})
        paginate "#{Repository.path repo}/pulls/#{pull_number}/requested_reviewers", options
      end

      # List reviews on a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @return [Array<Sawyer::Resource>] A list of reviews
      # @see https://developer.github.com/v3/pulls/reviews/#list-reviews-on-a-pull-request
      def pull_reviews(repo, pull_number, options = {})
        paginate "#{Repository.path repo}/pulls/#{pull_number}/reviews", options
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

      # Create a review request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @option options [Array] :reviewers An array of user logins that will be requested.
      # @option options [Array] :team_reviewers An array of team slugs that will be requested.
      # @return [Sawyer::Resource] The new request
      # @see https://developer.github.com/v3/pulls/review_requests/#create-a-review-request
      def create_review_request(repo, pull_number, options = {})
        post "#{Repository.path repo}/pulls/#{pull_number}/requested_reviewers", options
      end

      # Create a pull request review
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @option options [String] :commit_id The ID of the commit
      # @option options [String] :body Required when using REQUEST_CHANGES or COMMENT for the event parameter. The body text of the pull request review.
      # @option options [String] :event The review action you want to perform. The review actions include: APPROVE, REQUEST_CHANGES, or COMMENT. By leaving this blank, you set the review action state to PENDING, which means you will need to submit the pull request review (https://developer.github.com/v3/pulls/reviews/#submit-a-pull-request-review) when you are ready.
      # @option options [Array] :comments Use the following table to specify the location, destination, and contents of the draft review comment.
      # @return [Sawyer::Resource] The new review
      # @see https://developer.github.com/v3/pulls/reviews/#create-a-pull-request-review
      def create_pull_review(repo, pull_number, options = {})
        post "#{Repository.path repo}/pulls/#{pull_number}/reviews", options
      end

      # Create reaction for a pull request review comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @param content [String] The reaction type (https://developer.github.com/v3/reactions/#reaction-types) to add to the pull request review comment.
      # @return [Sawyer::Resource] The new reaction
      # @see https://developer.github.com/v3/reactions/#create-reaction-for-a-pull-request-review-comment
      def create_pull_request_review_comment_reaction(repo, comment_id, content, options = {})
        opts = options.dup
        opts[:content] = content.to_s.downcase
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        post "#{Repository.path repo}/pulls/comments/#{comment_id}/reactions", opts
      end

      # Update a pull request branch
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @option options [String] :expected_head_sha The expected SHA of the pull request's HEAD ref. This is the most recent commit on the pull request's branch. If the expected SHA does not match the pull request's HEAD, you will receive a 422 Unprocessable Entity status. You can use the "List commits on a repository (https://developer.github.com/v3/repos/commits/#list-commits-on-a-repository)" endpoint to find the most recent commit SHA. Default: SHA of the pull request's current HEAD ref.
      # @return [Sawyer::Resource] The updated pull
      # @see https://developer.github.com/v3/pulls/#update-a-pull-request-branch
      def update_pull_branch(repo, pull_number, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.lydian-preview+json' if opts[:accept].nil?

        put "#{Repository.path repo}/pulls/#{pull_number}/update-branch", opts
      end

      # Merge a pull request (Merge Button)
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @option options [String] :commit_title Title for the automatic commit message.
      # @option options [String] :commit_message Extra detail to append to automatic commit message.
      # @option options [String] :sha SHA that pull request head must match to allow merge.
      # @option options [String] :merge_method Merge method to use. Possible values are merge, squash or rebase. Default is merge.
      # @return [Sawyer::Resource] The updated pull
      # @see https://developer.github.com/v3/pulls/#merge-a-pull-request-merge-button
      def merge_pull(repo, pull_number, options = {})
        put "#{Repository.path repo}/pulls/#{pull_number}/merge", options
      end

      # Update a pull request review
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @param review_id [Integer] The ID of the review
      # @param body [String] The body text of the pull request review.
      # @return [Sawyer::Resource] The updated pull
      # @see https://developer.github.com/v3/pulls/reviews/#update-a-pull-request-review
      def update_pull_review(repo, pull_number, review_id, body, options = {})
        opts = options.dup
        opts[:body] = body
        put "#{Repository.path repo}/pulls/#{pull_number}/reviews/#{review_id}", opts
      end

      # Delete a review request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @option options [Array] :reviewers An array of user logins that will be removed.
      # @option options [Array] :team_reviewers An array of team slugs that will be removed.
      # @return [Sawyer::Resource] The updated pull
      # @see https://developer.github.com/v3/pulls/review_requests/#delete-a-review-request
      def delete_review_request(repo, pull_number, options = {})
        delete "#{Repository.path repo}/pulls/#{pull_number}/requested_reviewers", options
      end

      # Delete a pull request comment reaction
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @param reaction_id [Integer] The ID of the reaction
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/reactions/#delete-a-pull-request-comment-reaction
      def delete_pull_request_comment_reaction(repo, comment_id, reaction_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        boolean_from_response :delete, "#{Repository.path repo}/pulls/comments/#{comment_id}/reactions/#{reaction_id}", opts
      end

      # Delete a pending review
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @param review_id [Integer] The ID of the review
      # @return [Sawyer::Resource] The updated pull
      # @see https://developer.github.com/v3/pulls/reviews/#delete-a-pending-review
      def delete_pending_review(repo, pull_number, review_id, options = {})
        delete "#{Repository.path repo}/pulls/#{pull_number}/reviews/#{review_id}", options
      end

      # Get comments for a single review
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @param review_id [Integer] The ID of the review
      # @return [Array<Sawyer::Resource>] A list of comments
      # @see https://developer.github.com/v3/pulls/reviews/#get-comments-for-a-single-review
      def review_comments(repo, pull_number, review_id, options = {})
        paginate "#{Repository.path repo}/pulls/#{pull_number}/reviews/#{review_id}/comments", options
      end

      # Submit a pull request review
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @param review_id [Integer] The ID of the review
      # @param event [String] The review action you want to perform. The review actions include: APPROVE, REQUEST_CHANGES, or COMMENT. When you leave this blank, the API returns HTTP 422 (Unrecognizable entity) and sets the review action state to PENDING, which means you will need to re-submit the pull request review using a review action.
      # @option options [String] :body The body text of the pull request review
      # @return [Sawyer::Resource] The new review
      # @see https://developer.github.com/v3/pulls/reviews/#submit-a-pull-request-review
      def submit_pull_review(repo, pull_number, review_id, event, options = {})
        opts = options.dup
        opts[:event] = event.to_s.downcase
        post "#{Repository.path repo}/pulls/#{pull_number}/reviews/#{review_id}/events", opts
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

      # Dismiss a pull request review
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @param review_id [Integer] The ID of the review
      # @param message [String] The message for the pull request review dismissal
      # @return [Sawyer::Resource] The updated pull
      # @see https://developer.github.com/v3/pulls/reviews/#dismiss-a-pull-request-review
      def dismiss_pull_review(repo, pull_number, review_id, message, options = {})
        opts = options.dup
        opts[:message] = message
        put "#{Repository.path repo}/pulls/#{pull_number}/reviews/#{review_id}/dismissals", opts
      end
    end
  end
end

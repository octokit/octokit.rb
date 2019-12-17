module Octokit
  class Client
    # Methods for the Reactions API
    #
    # @see https://developer.github.com/v3/reactions/
    module Reactions

      # Delete a reaction
      #
      # @param reaction_id [Integer] The ID of the reaction
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/reactions/#delete-a-reaction
      def delete_reaction(reaction_id, options = {})
        opts = ensure_api_media_type(:reaction, options)
        boolean_from_response :delete, "/reactions/#{reaction_id}", opts
      end

      # List reactions for a commit comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @option options [String] :content Returns a single [reaction type](https://developer.github.com/v3/reactions/#reaction-types). Omit this parameter to list all reactions to a commit comment.
      # @return [Array<Sawyer::Resource>] A list of commit comment reactions
      # @see https://developer.github.com/v3/reactions/#list-reactions-for-a-commit-comment
      def commit_comment_reactions(repo, comment_id, options = {})
        opts = ensure_api_media_type(:reactions, options)
        paginate "#{Repository.path repo}/comments/#{comment_id}/reactions", opts
      end

      # Create reaction for a commit comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @param content [String] The [reaction type](https://developer.github.com/v3/reactions/#reaction-types) to add to the commit comment.
      # @return [Sawyer::Resource] The new commit comment reaction
      # @see https://developer.github.com/v3/reactions/#create-reaction-for-a-commit-comment
      def create_commit_comment_reaction(repo, comment_id, content, options = {})
        options[:content] = content.to_s.downcase
        opts = ensure_api_media_type(:commit_comment_reaction, options)
        post "#{Repository.path repo}/comments/#{comment_id}/reactions", opts
      end

      # List reactions for a pull request review comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @option options [String] :content Returns a single [reaction type](https://developer.github.com/v3/reactions/#reaction-types). Omit this parameter to list all reactions to a pull request review comment.
      # @return [Array<Sawyer::Resource>] A list of pull request review comment reactions
      # @see https://developer.github.com/v3/reactions/#list-reactions-for-a-pull-request-review-comment
      def pull_request_review_comment_reactions(repo, comment_id, options = {})
        opts = ensure_api_media_type(:reactions, options)
        paginate "#{Repository.path repo}/pulls/comments/#{comment_id}/reactions", opts
      end

      # List reactions for an issue comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @option options [String] :content Returns a single [reaction type](https://developer.github.com/v3/reactions/#reaction-types). Omit this parameter to list all reactions to an issue comment.
      # @return [Array<Sawyer::Resource>] A list of issue comment reactions
      # @see https://developer.github.com/v3/reactions/#list-reactions-for-an-issue-comment
      def issue_comment_reactions(repo, comment_id, options = {})
        opts = ensure_api_media_type(:reactions, options)
        paginate "#{Repository.path repo}/issues/comments/#{comment_id}/reactions", opts
      end

      # List reactions for an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @option options [String] :content Returns a single [reaction type](https://developer.github.com/v3/reactions/#reaction-types). Omit this parameter to list all reactions to an issue.
      # @return [Array<Sawyer::Resource>] A list of issue reactions
      # @see https://developer.github.com/v3/reactions/#list-reactions-for-an-issue
      def issue_reactions(repo, issue_number, options = {})
        opts = ensure_api_media_type(:reactions, options)
        paginate "#{Repository.path repo}/issues/#{issue_number}/reactions", opts
      end

      # Create reaction for a pull request review comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @param content [String] The [reaction type](https://developer.github.com/v3/reactions/#reaction-types) to add to the pull request review comment.
      # @return [Sawyer::Resource] The new pull request review comment reaction
      # @see https://developer.github.com/v3/reactions/#create-reaction-for-a-pull-request-review-comment
      def create_pull_request_review_comment_reaction(repo, comment_id, content, options = {})
        options[:content] = content.to_s.downcase
        opts = ensure_api_media_type(:pull_request_review_comment_reaction, options)
        post "#{Repository.path repo}/pulls/comments/#{comment_id}/reactions", opts
      end

      # Create reaction for an issue comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @param content [String] The [reaction type](https://developer.github.com/v3/reactions/#reaction-types) to add to the issue comment.
      # @return [Sawyer::Resource] The new issue comment reaction
      # @see https://developer.github.com/v3/reactions/#create-reaction-for-an-issue-comment
      def create_issue_comment_reaction(repo, comment_id, content, options = {})
        options[:content] = content.to_s.downcase
        opts = ensure_api_media_type(:issue_comment_reaction, options)
        post "#{Repository.path repo}/issues/comments/#{comment_id}/reactions", opts
      end

      # Create reaction for an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @param content [String] The [reaction type](https://developer.github.com/v3/reactions/#reaction-types) to add to the issue.
      # @return [Sawyer::Resource] The new issue reaction
      # @see https://developer.github.com/v3/reactions/#create-reaction-for-an-issue
      def create_issue_reaction(repo, issue_number, content, options = {})
        options[:content] = content.to_s.downcase
        opts = ensure_api_media_type(:issue_reaction, options)
        post "#{Repository.path repo}/issues/#{issue_number}/reactions", opts
      end
    end
  end
end

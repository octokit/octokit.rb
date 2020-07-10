# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Reactions API
    #
    # @see https://developer.github.com/v3/reactions/
    module Reactions
      # Delete a reaction (Legacy)
      #
      # @param reaction_id [Integer] The ID of the reaction
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/reactions/#delete-a-reaction-legacy
      def delete_reaction_legacy(reaction_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        boolean_from_response :delete, "reactions/#{reaction_id}", opts
      end

      # List reactions for a team discussion (Legacy)
      #
      # @param team_id [Integer] The ID of the team
      # @param discussion_number [Integer] The number of the discussion
      # @option options [String] :content Returns a single reaction type (https://developer.github.com/v3/reactions/#reaction-types). Omit this parameter to list all reactions to a team discussion.
      # @return [Array<Sawyer::Resource>] A list of reactions
      # @see https://developer.github.com/v3/reactions/#list-reactions-for-a-team-discussion-legacy
      def team_discussion_legacy_reactions(team_id, discussion_number, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        paginate "teams/#{team_id}/discussions/#{discussion_number}/reactions", opts
      end

      # Create reaction for a team discussion (Legacy)
      #
      # @param team_id [Integer] The ID of the team
      # @param discussion_number [Integer] The number of the discussion
      # @param content [String] The reaction type (https://developer.github.com/v3/reactions/#reaction-types) to add to the team discussion.
      # @return [Sawyer::Resource] The new reaction
      # @see https://developer.github.com/v3/reactions/#create-reaction-for-a-team-discussion-legacy
      def create_team_discussion_legacy_reaction(team_id, discussion_number, content, options = {})
        opts = options.dup
        opts[:content] = content.to_s.downcase
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        post "teams/#{team_id}/discussions/#{discussion_number}/reactions", opts
      end

      # List reactions for a commit comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @option options [String] :content Returns a single reaction type (https://developer.github.com/v3/reactions/#reaction-types). Omit this parameter to list all reactions to a commit comment.
      # @return [Array<Sawyer::Resource>] A list of reactions
      # @see https://developer.github.com/v3/reactions/#list-reactions-for-a-commit-comment
      def commit_comment_reactions(repo, comment_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        paginate "#{Repository.path repo}/comments/#{comment_id}/reactions", opts
      end

      # Create reaction for a commit comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @param content [String] The reaction type (https://developer.github.com/v3/reactions/#reaction-types) to add to the commit comment.
      # @return [Sawyer::Resource] The new reaction
      # @see https://developer.github.com/v3/reactions/#create-reaction-for-a-commit-comment
      def create_commit_comment_reaction(repo, comment_id, content, options = {})
        opts = options.dup
        opts[:content] = content.to_s.downcase
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        post "#{Repository.path repo}/comments/#{comment_id}/reactions", opts
      end

      # Delete a commit comment reaction
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @param reaction_id [Integer] The ID of the reaction
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/reactions/#delete-a-commit-comment-reaction
      def delete_commit_comment_reaction(repo, comment_id, reaction_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        boolean_from_response :delete, "#{Repository.path repo}/comments/#{comment_id}/reactions/#{reaction_id}", opts
      end

      # List reactions for an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @option options [String] :content Returns a single reaction type (https://developer.github.com/v3/reactions/#reaction-types). Omit this parameter to list all reactions to an issue.
      # @return [Array<Sawyer::Resource>] A list of reactions
      # @see https://developer.github.com/v3/reactions/#list-reactions-for-an-issue
      def issue_reactions(repo, issue_number, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        paginate "#{Repository.path repo}/issues/#{issue_number}/reactions", opts
      end

      # List reactions for a team discussion comment (Legacy)
      #
      # @param team_id [Integer] The ID of the team
      # @param discussion_number [Integer] The number of the discussion
      # @param comment_number [Integer] The number of the comment
      # @option options [String] :content Returns a single reaction type (https://developer.github.com/v3/reactions/#reaction-types). Omit this parameter to list all reactions to a team discussion comment.
      # @return [Array<Sawyer::Resource>] A list of reactions
      # @see https://developer.github.com/v3/reactions/#list-reactions-for-a-team-discussion-comment-legacy
      def team_discussion_comment_legacy_reactions(team_id, discussion_number, comment_number, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        paginate "teams/#{team_id}/discussions/#{discussion_number}/comments/#{comment_number}/reactions", opts
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

      # List reactions for an issue comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @option options [String] :content Returns a single reaction type (https://developer.github.com/v3/reactions/#reaction-types). Omit this parameter to list all reactions to an issue comment.
      # @return [Array<Sawyer::Resource>] A list of reactions
      # @see https://developer.github.com/v3/reactions/#list-reactions-for-an-issue-comment
      def issue_comment_reactions(repo, comment_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        paginate "#{Repository.path repo}/issues/comments/#{comment_id}/reactions", opts
      end

      # Create reaction for an issue comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @param content [String] The reaction type (https://developer.github.com/v3/reactions/#reaction-types) to add to the issue comment.
      # @return [Sawyer::Resource] The new reaction
      # @see https://developer.github.com/v3/reactions/#create-reaction-for-an-issue-comment
      def create_issue_comment_reaction(repo, comment_id, content, options = {})
        opts = options.dup
        opts[:content] = content.to_s.downcase
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        post "#{Repository.path repo}/issues/comments/#{comment_id}/reactions", opts
      end

      # Create reaction for an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @param content [String] The reaction type (https://developer.github.com/v3/reactions/#reaction-types) to add to the issue.
      # @return [Sawyer::Resource] The new reaction
      # @see https://developer.github.com/v3/reactions/#create-reaction-for-an-issue
      def create_issue_reaction(repo, issue_number, content, options = {})
        opts = options.dup
        opts[:content] = content.to_s.downcase
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        post "#{Repository.path repo}/issues/#{issue_number}/reactions", opts
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

      # Create reaction for a team discussion comment (Legacy)
      #
      # @param team_id [Integer] The ID of the team
      # @param discussion_number [Integer] The number of the discussion
      # @param comment_number [Integer] The number of the comment
      # @param content [String] The reaction type (https://developer.github.com/v3/reactions/#reaction-types) to add to the team discussion comment.
      # @return [Sawyer::Resource] The new reaction
      # @see https://developer.github.com/v3/reactions/#create-reaction-for-a-team-discussion-comment-legacy
      def create_team_discussion_comment_legacy_reaction(team_id, discussion_number, comment_number, content, options = {})
        opts = options.dup
        opts[:content] = content.to_s.downcase
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        post "teams/#{team_id}/discussions/#{discussion_number}/comments/#{comment_number}/reactions", opts
      end

      # Delete an issue reaction
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @param reaction_id [Integer] The ID of the reaction
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/reactions/#delete-an-issue-reaction
      def delete_issue_reaction(repo, issue_number, reaction_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        boolean_from_response :delete, "#{Repository.path repo}/issues/#{issue_number}/reactions/#{reaction_id}", opts
      end

      # Delete an issue comment reaction
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @param reaction_id [Integer] The ID of the reaction
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/reactions/#delete-an-issue-comment-reaction
      def delete_issue_comment_reaction(repo, comment_id, reaction_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        boolean_from_response :delete, "#{Repository.path repo}/issues/comments/#{comment_id}/reactions/#{reaction_id}", opts
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

      # List reactions for a team discussion
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @param team_slug [String] The slug of the team
      # @param discussion_number [Integer] The number of the discussion
      # @option options [String] :content Returns a single reaction type (https://developer.github.com/v3/reactions/#reaction-types). Omit this parameter to list all reactions to a team discussion.
      # @return [Array<Sawyer::Resource>] A list of reactions
      # @see https://developer.github.com/v3/reactions/#list-reactions-for-a-team-discussion
      def team_discussion_in_org_reactions(org, team_slug, discussion_number, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        paginate "#{Organization.path org}/teams/#{team_slug}/discussions/#{discussion_number}/reactions", opts
      end

      # Create reaction for a team discussion
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @param team_slug [String] The slug of the team
      # @param discussion_number [Integer] The number of the discussion
      # @param content [String] The reaction type (https://developer.github.com/v3/reactions/#reaction-types) to add to the team discussion.
      # @return [Sawyer::Resource] The new reaction
      # @see https://developer.github.com/v3/reactions/#create-reaction-for-a-team-discussion
      def create_team_discussion_in_org_reaction(org, team_slug, discussion_number, content, options = {})
        opts = options.dup
        opts[:content] = content.to_s.downcase
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        post "#{Organization.path org}/teams/#{team_slug}/discussions/#{discussion_number}/reactions", opts
      end

      # Delete team discussion reaction
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @param team_slug [String] The slug of the team
      # @param discussion_number [Integer] The number of the discussion
      # @param reaction_id [Integer] The ID of the reaction
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/reactions/#delete-team-discussion-reaction
      def delete_team_discussion_reaction(org, team_slug, discussion_number, reaction_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        boolean_from_response :delete, "#{Organization.path org}/teams/#{team_slug}/discussions/#{discussion_number}/reactions/#{reaction_id}", opts
      end

      # List reactions for a team discussion comment
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @param team_slug [String] The slug of the team
      # @param discussion_number [Integer] The number of the discussion
      # @param comment_number [Integer] The number of the comment
      # @option options [String] :content Returns a single reaction type (https://developer.github.com/v3/reactions/#reaction-types). Omit this parameter to list all reactions to a team discussion comment.
      # @return [Array<Sawyer::Resource>] A list of reactions
      # @see https://developer.github.com/v3/reactions/#list-reactions-for-a-team-discussion-comment
      def team_discussion_comment_in_org_reactions(org, team_slug, discussion_number, comment_number, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        paginate "#{Organization.path org}/teams/#{team_slug}/discussions/#{discussion_number}/comments/#{comment_number}/reactions", opts
      end

      # Create reaction for a team discussion comment
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @param team_slug [String] The slug of the team
      # @param discussion_number [Integer] The number of the discussion
      # @param comment_number [Integer] The number of the comment
      # @param content [String] The reaction type (https://developer.github.com/v3/reactions/#reaction-types) to add to the team discussion comment.
      # @return [Sawyer::Resource] The new reaction
      # @see https://developer.github.com/v3/reactions/#create-reaction-for-a-team-discussion-comment
      def create_team_discussion_comment_in_org_reaction(org, team_slug, discussion_number, comment_number, content, options = {})
        opts = options.dup
        opts[:content] = content.to_s.downcase
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        post "#{Organization.path org}/teams/#{team_slug}/discussions/#{discussion_number}/comments/#{comment_number}/reactions", opts
      end

      # Delete team discussion comment reaction
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @param team_slug [String] The slug of the team
      # @param discussion_number [Integer] The number of the discussion
      # @param comment_number [Integer] The number of the comment
      # @param reaction_id [Integer] The ID of the reaction
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/reactions/#delete-team-discussion-comment-reaction
      def delete_team_discussion_comment_reaction(org, team_slug, discussion_number, comment_number, reaction_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.squirrel-girl-preview+json' if opts[:accept].nil?

        boolean_from_response :delete, "#{Organization.path org}/teams/#{team_slug}/discussions/#{discussion_number}/comments/#{comment_number}/reactions/#{reaction_id}", opts
      end
    end
  end
end

module Octokit
  class Client
    module EnterpriseStats

      # Get all available Enterprise stats
      #
      # @return [Array<Hashie::Mash>] Array of all Enterprise stats
      # @see https://support.enterprise.github.com/entries/21188836-admin-stats-api
      # @example Get all Enterprise stats
      #   @client.enterprise_stats
      def enterprise_stats
        get_enterprise_stats("all")
      end

      # Get repository-related Enterprise stats
      #
      # @return [Array<Hashie::Mash>] Array of repository-related Enterprise stats
      # @see https://support.enterprise.github.com/entries/21188836-admin-stats-api
      # @example Get repository-related Enterprise stats
      #   @client.enterprise_repository_stats
      def enterprise_repository_stats
        get_enterprise_stats("repos")
      end

      # Get hooks-related Enterprise stats
      #
      # @return [Array<Hashie::Mash>] Array of hooks-related Enterprise stats
      # @see https://support.enterprise.github.com/entries/21188836-admin-stats-api
      # @example Get hooks-related Enterprise stats
      #   @client.enterprise_hooks_stats
      def enterprise_hooks_stats
        get_enterprise_stats("hooks")
      end

      # Get pages-related Enterprise stats
      #
      # @return [Array<Hashie::Mash>] Array of pages-related Enterprise stats
      # @see https://support.enterprise.github.com/entries/21188836-admin-stats-api
      # @example Get pages-related Enterprise stats
      #   @client.enterprise_pages_stats
      def enterprise_pages_stats
        get_enterprise_stats("pages")
      end

      # Get organization-related Enterprise stats
      #
      # @return [Array<Hashie::Mash>] Array of organization-related Enterprise stats
      # @see https://support.enterprise.github.com/entries/21188836-admin-stats-api
      # @example Get organization-related Enterprise stats
      #   @client.enterprise_organization_stats
      def enterprise_organization_stats
        get_enterprise_stats("orgs")
      end

      # Get user-related Enterprise stats
      #
      # @return [Array<Hashie::Mash>] Array of user-related Enterprise stats
      # @see https://support.enterprise.github.com/entries/21188836-admin-stats-api
      # @example Get user-related Enterprise stats
      #   @client.enterprise_users_stats
      def enterprise_users_stats
        get_enterprise_stats("users")
      end

      # Get pull requests-related Enterprise stats
      #
      # @return [Array<Hashie::Mash>] Array of pull requests-related Enterprise stats
      # @see https://support.enterprise.github.com/entries/21188836-admin-stats-api
      # @example Get pull requests-related Enterprise stats
      #   @client.enterprise_pull_requests_stats
      def enterprise_pull_requests_stats
        get_enterprise_stats("pulls")
      end

      # Get issue-related Enterprise stats
      #
      # @return [Array<Hashie::Mash>] Array of issue-related Enterprise stats
      # @see https://support.enterprise.github.com/entries/21188836-admin-stats-api
      # @example Get issue-related Enterprise stats
      #   @client.enterprise_issues_stats
      def enterprise_issues_stats
        get_enterprise_stats("issues")
      end

      # Get milestone-related Enterprise stats
      #
      # @return [Array<Hashie::Mash>] Array of milestone-related Enterprise stats
      # @see https://support.enterprise.github.com/entries/21188836-admin-stats-api
      # @example Get milestone-related Enterprise stats
      #   @client.enterprise_milestones_stats
      def enterprise_milestones_stats
        get_enterprise_stats("milestones")
      end

      # Get gist-related Enterprise stats
      #
      # @return [Array<Hashie::Mash>] Array of gist-related Enterprise stats
      # @see https://support.enterprise.github.com/entries/21188836-admin-stats-api
      # @example Get gist-related Enterprise stats
      #   @client.enterprise_gists_stats
      def enterprise_gists_stats
        get_enterprise_stats("gists")
      end

      # Get comment-related Enterprise stats
      #
      # @return [Array<Hashie::Mash>] Array of comment-related Enterprise stats
      # @see https://support.enterprise.github.com/entries/21188836-admin-stats-api
      # @example Get comment-related Enterprise stats
      #   @client.enterprise_comments_stats
      def enterprise_comments_stats
        get_enterprise_stats("comments")
      end

      private

      def get_enterprise_stats(metric)
        get("enterprise/stats/#{metric}")
      end
    end
  end
end

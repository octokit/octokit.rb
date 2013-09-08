module Octokit
  class Client

    # Methods for the (Enterprise) Admin Stats API
    #
    # @see https://enterprise.github.com/help/articles/admin-stats-api
    module EnterpriseStats

      # Get all available stats
      #
      # @return [Sawyer::Resource] All available stats
      # @example Get all available stats
      #   @client.enterprise_stats
      def enterprise_stats
        get_enterprise_stats("all")
      end
      
      # Get only repository-related stats
      #
      # @return [Sawyer::Resource] Only repository-related stats
      # @example Get only repository-related stats
      #   @client.enterprise_repository_stats
      def enterprise_repository_stats
        get_enterprise_stats("repos")
      end
      
      # Get only hooks-related stats
      #
      # @return [Sawyer::Resource] Only hooks-related stats
      # @example Get only hooks-related stats
      #   @client.enterprise_hooks_stats
      def enterprise_hooks_stats
        get_enterprise_stats("hooks")
      end
      
      # Get only pages-related stats
      #
      # @return [Sawyer::Resource] Only pages-related stats
      # @example Get only pages-related stats
      #   @client.enterprise_pages_stats
      def enterprise_pages_stats
        get_enterprise_stats("pages")
      end
      
      # Get only organization-related stats
      #
      # @return [Sawyer::Resource] Only organization-related stats
      # @example Get only organization-related stats
      #   @client.enterprise_organization_stats
      def enterprise_organization_stats
        get_enterprise_stats("orgs")
      end
      
      # Get only user-related stats
      #
      # @return [Sawyer::Resource] Only user-related stats
      # @example Get only user-related stats
      #   @client.enterprise_users_stats
      def enterprise_users_stats
        get_enterprise_stats("users")
      end
      
      # Get only pull request-related stats
      #
      # @return [Sawyer::Resource] Only pull request-related stats
      # @example Get only pull request-related stats
      #   @client.enterprise_pull_requests_stats
      def enterprise_pull_requests_stats
        get_enterprise_stats("pulls")
      end
      
      # Get only issue-related stats
      #
      # @return [Sawyer::Resource] Only issue-related stats
      # @example Get only issue-related stats
      #   @client.enterprise_issues_stats
      def enterprise_issues_stats
        get_enterprise_stats("issues")
      end
      
      # Get only milestone-related stats
      #
      # @return [Sawyer::Resource] Only milestone-related stats
      # @example Get only milestone-related stats
      #   @client.enterprise_milestones_stats
      def enterprise_milestones_stats
        get_enterprise_stats("milestones")
      end
      
      # Get only gist-related stats
      #
      # @return [Sawyer::Resource] Only only gist-related stats
      # @example Get only gist-related stats
      #   @client.enterprise_gits_stats
      def enterprise_gists_stats
        get_enterprise_stats("gists")
      end
      
      # Get only comment-related stats
      #
      # @return [Sawyer::Resource] Only comment-related stats
      # @example Get only comment-related stats
      #   @client.enterprise_comments_stats
      def enterprise_comments_stats
        get_enterprise_stats("comments")
      end

      private
      
      # @private Get enterprise stats
      #
      # @param metric [String] The metrics you are looking for
      # @return [Sawyer::Resource] Magical unicorn stats
      def get_enterprise_stats(metric)
        data = get("enterprise/stats/#{metric}")
        
        last_response.status == 202 ? nil : data
      end 

    end
  end
end

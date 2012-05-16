module Octokit
  class Client
    module Organizations
      def organization(org, options={})
        get("orgs/#{org}", options, 3)
      end
      alias :org :organization

      def update_organization(org, values, options={})
        patch("orgs/#{org}", options.merge({:organization => values}), 3)
      end
      alias :update_org :update_organization

      def organizations(user=nil, options={})
        if user
          get("users/#{user}/orgs", options, 3)
        else
          get("user/orgs", options, 3)
        end
      end
      alias :list_organizations :organizations
      alias :list_orgs :organizations
      alias :orgs :organizations

      def organization_repositories(org=nil, options={})
        if org.nil?
          warn 'DEPRECATED: Please pass org name to list repos.'
          get("/api/v2/json/organizations/repositories", options, 2)
        else
          get("orgs/#{org}/repos", options, 3)
        end
      end
      alias :org_repositories :organization_repositories
      alias :org_repos :organization_repositories

      def organization_members(org, options={})
        get("orgs/#{org}/members", options, 3)
      end
      alias :org_members :organization_members

      def organization_teams(org, options={})
        get("orgs/#{org}/teams", options, 3)
      end
      alias :org_teams :organization_teams

      def create_team(org, options={})
        post("orgs/#{org}/teams", options, 3)
      end

      def team(team_id, options={})
        get("teams/#{team_id}", options, 3)
      end

      def update_team(team_id, options={})
        patch("teams/#{team_id}", options, 3)
      end

      def delete_team(team_id, options={})
        delete("teams/#{team_id}", options, 3, true, true)
      end

      def team_members(team_id, options={})
        get("teams/#{team_id}/members", options, 3)
      end

      def add_team_member(team_id, user, options={})
        # There's a bug in this API call. The docs say to leave the body blank,
        # but it fails if the body is both blank and the content-length header
        # is not 0.
        put("teams/#{team_id}/members/#{user}", options.merge({:name => user}), 3, true, raw=true).status == 204
      end

      def remove_team_member(team_id, user, options={})
        delete("teams/#{team_id}/members/#{user}", options, 3, true, raw=true).status == 204
      end

      def team_repositories(team_id, options={})
        get("teams/#{team_id}/repos", options, 3)
      end
      alias :team_repos :team_repositories

      def add_team_repository(team_id, repo, options={})
        put("teams/#{team_id}/repos/#{Repository.new(repo)}", options.merge(:name => Repository.new(repo)), 3, true, raw=true).status == 204
      end
      alias :add_team_repo :add_team_repository

      def remove_team_repository(team_id, repo, options={})
        delete("teams/#{team_id}/repos/#{Repository.new(repo)}", options, 3, true, raw=true).status == 204
      end
      alias :remove_team_repo :remove_team_repository

      def publicize_membership(org, user, options={})
        put("orgs/#{org}/public_members/#{user}", options, 3, true, raw=true).status == 204
      end

      def unpublicize_membership(org, user, options={})
        delete("orgs/#{org}/public_members/#{user}", options, 3, true, raw=true).status == 204
      end
      alias :conceal_membership :unpublicize_membership

    end
  end
end

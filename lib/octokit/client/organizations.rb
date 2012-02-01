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
        if org
          get("orgs/#{org}/repos", options, 3)
        else
          get("/api/v2/json/organizations/repositories", options)["repositories"]
        end
      end
      alias :org_repositories :organization_repositories
      alias :org_repos :organization_repositories

      def organization_members(org, options={})
        get("/api/v2/json/organizations/#{org}/public_members", options)['users']
      end
      alias :org_members :organization_members

      def organization_teams(org, options={})
        get("orgs/#{org}/teams", options, 3)
      end
      alias :org_teams :organization_teams

      def create_team(org, values, options={})
        post("orgs/#{org}/teams", options.merge({:team => values}), 3)
      end

      def team(team_id, options={})
        get("teams/#{team_id}", options, 3)
      end

      def update_team(team_id, values, options={})
        patch("teams/#{team_id}", options.merge({:team => values}), 3)
      end

      def delete_team(team_id, options={})
        delete("teams/#{team_id}", options, 3, true, true)
      end

      def team_members(team_id, options={})
        get("/api/v2/json/teams/#{team_id}/members", options)['users']
      end

      def add_team_member(team_id, user, options={})
        post("/api/v2/json/teams/#{team_id}/members", options.merge({:name => user}))['user']
      end

      def remove_team_member(team_id, user, options={})
        delete("/api/v2/json/teams/#{team_id}/members", options.merge({:name => user}))['user']
      end

      def team_repositories(team_id, options={})
        get("/api/v2/json/teams/#{team_id}/repositories", options)['repositories']
      end
      alias :team_repos :team_repositories

      def add_team_repository(team_id, repo, options={})
        post("/api/v2/json/teams/#{team_id}/repositories", options.merge(:name => Repository.new(repo)))['repositories']
      end
      alias :add_team_repo :add_team_repository

      def remove_team_repository(team_id, repo, options={})
        delete("/api/v2/json/teams/#{team_id}/repositories", options.merge(:name => Repository.new(repo)))['repositories']
      end
      alias :remove_team_repo :remove_team_repository
    end
  end
end

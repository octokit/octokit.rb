module Octokit
  class Client
    module Organizations

      def organization(org, options={})
        get("organizations/#{org}", options)['organization']
      end
      alias :org :organization

      def update_organization(org, values, options={})
        put("organizations/#{org}", options.merge({:organization => values}))['organization']
      end
      alias :update_org :update_organization

      def organizations(user=nil, options={})
        if user
          get("user/show/#{user}/organizations", options)
        else
          get("organizations", options)
        end['organizations']
      end
      alias :list_organizations :organizations
      alias :list_orgs :organizations
      alias :orgs :organizations

      def organization_repositories(org, options={})
        if org
          get("organizations/#{org}/public_repositories", options)
        else
          get("organizations/repositories", options)
        end['repositories']
      end
      alias :org_repositories :organization_repositories
      alias :org_repos :organization_repositories

      def organization_members(org, options={})
        get("organizations/#{org}/public_members", options)['users']
      end
      alias :org_members :organization_members

      def teams(org, options={})
        get("organizations/#{org}/teams", options)['teams']
      end

      def create_team(org, values, options={})
        post("organizations/#{org}/teams", options.merge({:team => values}))['team']
      end

      def team(team_id, options={})
        get("teams/#{team_id}", options)['team']
      end

      def update_team(team_id, values, options={})
        put("teams/#{team_id}", options.merge({:team => values}))['team']
      end

      def delete_team(team_id, options={})
        delete("teams/#{team_id}", options)['team']
      end

      def team_members(team_id, options={})
        get("teams/#{team_id}/members", options)['users']
      end

      def add_team_member(team_id, user, options={})
        post("teams/#{team_id}/members", options.merge({:name => user}))['user']
      end

      def remove_team_member(team_id, user, options={})
        delete("teams/#{team_id}/members", options.merge({:name => user}))['user']
      end

      def team_repositories(team_id, options={})
        get("teams/#{team_id}/repositories", options)['repositories']
      end
      alias :team_repos :team_repositories

      def add_team_repository(team_id, repo, options={})
        post("teams/#{team_id}/repositories", options.merge(:name => Repository.new(repo)))['repositories']
      end
      alias :add_team_repo :add_team_repository

      def remove_team_repository(team_id, repo, options={})
        delete("teams/#{team_id}/repositories", options.merge(:name => Repository.new(repo)))['repositories']
      end
      alias :remove_team_repo :remove_team_repository
    end
  end
end

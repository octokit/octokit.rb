module Octokit
  class Client
    module Repositories
      def search_repositories(q, options={})
        get("/api/v2/json/repos/search/#{q}", options)['repositories']
      end
      alias :search_repos :search_repositories

      def repository(repo, options={})
        get "/repos/#{Repository.new repo}", options, 3
      end
      alias :repo :repository

      def edit_repository(repo, options={})
        patch "/repos/#{Repository.new repo}", options, 3
      end
      alias :edit :edit_repository
      alias :update_repository :edit_repository
      alias :update :edit_repository

      def repositories(username=nil, options={})
        if username.nil?
          get '/user/repos', options, 3
        else
          get "/users/#{username}/repos", options, 3
        end
      end
      alias :list_repositories :repositories
      alias :list_repos :repositories
      alias :repos :repositories

      def watch(repo, options={})
        put "/user/watched/#{Repository.new repo}", options, 3
      end

      def unwatch(repo, options={})
        delete "/user/watched/#{Repository.new repo}", options, 3
      end

      def fork(repo, options={})
        post "/repos/#{Repository.new repo}/forks", options, 3
      end

      def create_repository(name, options={})
        organization = options.delete :organization
        options.merge! :name => name

        if organization.nil?
          post '/user/repos', options, 3
        else
          post "/orgs/#{organization}/repos", options, 3
        end
      end
      alias :create_repo :create_repository
      alias :create :create_repository

      def delete_repository(repo, options={})
        response = post("/api/v2/json/repos/delete/#{Repository.new(repo)}", options)
        if response.respond_to?(:delete_token)
          response['delete_token']
        else
          response
        end
      end
      alias :delete_repo :delete_repository

      def delete_repository!(repo, options={})
        delete_token = delete_repository(repo, options)
        post("/api/v2/json/repos/delete/#{Repository.new(repo)}", options.merge(:delete_token => delete_token))
      end
      alias :delete_repo! :delete_repository!

      def set_private(repo, options={})
        update_repository repo, options.merge({ :public => false })
      end

      def set_public(repo, options={})
        update_repository repo, options.merge({ :public => true })
      end

      def deploy_keys(repo, options={})
        get "/repos/#{Repository.new repo}/keys", options, 3
      end
      alias :list_deploy_keys :deploy_keys

      def add_deploy_key(repo, title, key, options={})
        post "/repos/#{Repository.new repo}/keys", options.merge(:title => title, :key => key), 3
      end

      def remove_deploy_key(repo, id, options={})
        delete "/repos/#{Repository.new repo}/keys/#{id}", options, 3
      end

      def collaborators(repo, options={})
        get "/repos/#{Repository.new repo}/collaborators", options, 3
      end
      alias :collabs :collaborators

      def add_collaborator(repo, collaborator, options={})
        put "/repos/#{Repository.new repo}/collaborators/#{collaborator}", options, 3
      end
      alias :add_collab :add_collaborator

      def remove_collaborator(repo, collaborator, options={})
        delete "/repos/#{Repository.new repo}/collaborators/#{collaborator}", options, 3
      end
      alias :remove_collab :remove_collaborator

      def pushable(options={})
        get("/api/v2/json/repos/pushable", options)['repositories']
      end

      def repository_teams(repo, options={})
        get "/repos/#{Repository.new repo}/teams", options, 3
      end
      alias :repo_teams :repository_teams
      alias :teams :repository_teams

      def contributors(repo, anon=false, options={})
        get "/repos/#{Repository.new repo}/contributors", options.merge(:anon => anon), 3
      end
      alias :contribs :contributors

      def watchers(repo, options={})
        get "/repos/#{Repository.new repo}/watchers", options, 3
      end

      def forks(repo, options={})
        get "/repos/#{Repository.new repo}/forks", options, 3
      end
      alias :network :forks

      def languages(repo, options={})
        get "/repos/#{Repository.new repo}/languages", options, 3
      end

      def tags(repo, options={})
        get "/repos/#{Repository.new repo}/tags", options, 3
      end

      def branches(repo, options={})
        get "/repos/#{Repository.new repo}/branches", options, 3
      end
    end
  end
end

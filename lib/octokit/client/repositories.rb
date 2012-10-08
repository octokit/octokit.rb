module Octokit
  class Client
    module Repositories

      # Legacy repository search
      #
      # @see http://developer.github.com/v3/search/#search-repositories
      # @param q [String] Search keyword
      # @return [Array<Hashie::Mash>] List of repositories found
      def search_repositories(q, options={})
        get("legacy/repos/search/#{q}", options, 3)['repositories']
      end
      alias :search_repos :search_repositories

      # Get a single repository
      #
      # @see http://developer.github.com/v3/repos/#get
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Hashie::Mash] Repository information
      def repository(repo, options={})
        get "repos/#{Repository.new repo}", options, 3
      end
      alias :repo :repository

      # Edit a repository
      #
      # @see http://developer.github.com/v3/repos/#edit
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param options [Hash] Repository information to update
      # @option options [String] :name Name of the repo
      # @option options [String] :description Description of the repo
      # @option options [String] :homepage Home page of the repo
      # @option options [String] :private `true` makes the repository private, and `false` makes it public.
      # @option options [String] :has_issues `true` enables issues for this repo, `false` disables issues.
      # @option options [String] :has_wiki `true` enables wiki for this repo, `false` disables wiki.
      # @option options [String] :has_downloads `true` enables downloads for this repo, `false` disables downloads.
      # @return [Hashie::Mash] Repository information
      def edit_repository(repo, options={})
        patch "repos/#{Repository.new repo}", options, 3
      end
      alias :edit :edit_repository
      alias :update_repository :edit_repository
      alias :update :edit_repository

      # List repositories
      #
      # If username is not supplied, repositories for the current
      # authenticated user are returned
      #
      # @see http://developer.github.com/v3/repos/#list-your-repositories
      # @param username [String] Optional username for which to list repos
      # @return [Array<Hashie::Mash>] List of repositories
      def repositories(username=nil, options={})
        if username.nil?
          get 'user/repos', options, 3
        else
          get "users/#{username}/repos", options, 3
        end
      end
      alias :list_repositories :repositories
      alias :list_repos :repositories
      alias :repos :repositories

      # Star a repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Boolean] `true` if successfully starred
      def star(repo, options={})
        begin
          put "user/starred/#{Repository.new repo}", options, 3
          return true
        rescue Octokit::NotFound
          return false
        end
      end

      # Unstar a repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Boolean] `true` if successfully unstarred
      def unstar(repo, options={})
        begin
          delete "user/starred/#{Repository.new repo}", options, 3
          return true
        rescue Octokit::NotFound
          return false
        end
      end

      # Watch a repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Boolean] `true` if successfully watched
      # @deprecated Use #star instead
      def watch(repo, options={})
        begin
          put "user/watched/#{Repository.new repo}", options, 3
          return true
        rescue Octokit::NotFound
          return false
        end
      end

      # Unwatch a repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Boolean] `true` if successfully unwatched
      # @deprecated Use #unstar instead
      def unwatch(repo, options={})
        begin
          delete "user/watched/#{Repository.new repo}", options, 3
          return true
        rescue Octokit::NotFound
          return false
        end
      end

      # Fork a repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Hashie::Mash] Repository info for the new fork
      def fork(repo, options={})
        post "repos/#{Repository.new repo}/forks", options, 3
      end

      # Create a repository for a user or organization
      #
      # @param name [String] Name of the new repo
      # @option options [String] :description Description of the repo
      # @option options [String] :homepage Home page of the repo
      # @option options [String] :private `true` makes the repository private, and `false` makes it public.
      # @option options [String] :has_issues `true` enables issues for this repo, `false` disables issues.
      # @option options [String] :has_wiki `true` enables wiki for this repo, `false` disables wiki.
      # @option options [String] :has_downloads `true` enables downloads for this repo, `false` disables downloads.
      # @option options [String] :organization Short name for the org under which to create the repo.
      # @option options [Integer] :team_id The id of the team that will be granted access to this repository. This is only valid when creating a repo in an organization.
      # @option options [Boolean] :auto_init `true` to create an initial commit with empty README. Default is `false`.
      # @option options [String] :gitignore_template Desired language or platform .gitignore template to apply. Ignored if auto_init parameter is not provided.
      # @return [Hashie::Mash] Repository info for the new repository
      # @see http://developer.github.com/v3/repos/#create
      def create_repository(name, options={})
        organization = options.delete :organization
        options.merge! :name => name

        if organization.nil?
          post 'user/repos', options, 3
        else
          post "orgs/#{organization}/repos", options, 3
        end
      end
      alias :create_repo :create_repository
      alias :create :create_repository

      # Delete repository
      #
      # Note: If OAuth is used, 'delete_repo' scope is required
      #
      # @see http://developer.github.com/v3/repos/#delete-a-repository
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Boolean] `true` if repository was deleted
      def delete_repository(repo, options={})
        begin
          delete "repos/#{Repository.new repo}", options, 3
          return true
        rescue Octokit::NotFound
          return false
        end
      end
      alias :delete_repo :delete_repository

      # Hide a public repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Hashie::Mash] Updated repository info
      def set_private(repo, options={})
        # GitHub Api for setting private updated to use private attr, rather than public
        update_repository repo, options.merge({ :private => true })
      end

      # Unhide a private repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Hashie::Mash] Updated repository info
      def set_public(repo, options={})
        # GitHub Api for setting private updated to use private attr, rather than public
        update_repository repo, options.merge({ :private => false })
      end

      def deploy_keys(repo, options={})
        get "repos/#{Repository.new repo}/keys", options, 3
      end
      alias :list_deploy_keys :deploy_keys

      def add_deploy_key(repo, title, key, options={})
        post "repos/#{Repository.new repo}/keys", options.merge(:title => title, :key => key), 3
      end

      def remove_deploy_key(repo, id, options={})
        delete "repos/#{Repository.new repo}/keys/#{id}", options, 3
      end

      def collaborators(repo, options={})
        get "repos/#{Repository.new repo}/collaborators", options, 3
      end
      alias :collabs :collaborators

      def add_collaborator(repo, collaborator, options={})
        put "repos/#{Repository.new repo}/collaborators/#{collaborator}", options, 3
      end
      alias :add_collab :add_collaborator

      def remove_collaborator(repo, collaborator, options={})
        delete "repos/#{Repository.new repo}/collaborators/#{collaborator}", options, 3
      end
      alias :remove_collab :remove_collaborator

      def repository_teams(repo, options={})
        get "repos/#{Repository.new repo}/teams", options, 3
      end
      alias :repo_teams :repository_teams
      alias :teams :repository_teams

      def contributors(repo, anon=false, options={})
        get "repos/#{Repository.new repo}/contributors", options.merge(:anon => anon), 3
      end
      alias :contribs :contributors

      def stargazers(repo, options={})
        get "repos/#{Repository.new repo}/stargazers", options, 3
      end

      def watchers(repo, options={})
        get "repos/#{Repository.new repo}/watchers", options, 3
      end

      def forks(repo, options={})
        get "repos/#{Repository.new repo}/forks", options, 3
      end
      alias :network :forks

      def languages(repo, options={})
        get "repos/#{Repository.new repo}/languages", options, 3
      end

      def tags(repo, options={})
        get "repos/#{Repository.new repo}/tags", options, 3
      end

      def branches(repo, options={})
        get "repos/#{Repository.new repo}/branches", options, 3
      end

      # Get a single branch from a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param branch [String] Branch name
      # @return [Branch] The branch requested, if it exists
      # @see http://developer.github.com/v3/repos/#get-branch
      # @example Get branch 'master` from pengwynn/octokit
      #   Octokit.issue("pengwynn/octokit", "master")
      def branch(repo, branch, options={})
        get "repos/#{Repository.new repo}/branches/#{branch}", options, 3
      end
      alias :get_branch :branch

      def hooks(repo, options={})
        get "repos/#{Repository.new repo}/hooks", options, 3
      end

      def hook(repo, id, options={})
        get "repos/#{Repository.new repo}/hooks/#{id}", options, 3
      end

      def create_hook(repo, name, config, options={})
        options = {:name => name, :config => config, :events => ["push"], :active => true}.merge(options)
        post "repos/#{Repository.new repo}/hooks", options, 3
      end

      def edit_hook(repo, id, name, config, options={})
        options = {:name => name, :config => config, :events => ["push"], :active => true}.merge(options)
        patch "repos/#{Repository.new repo}/hooks/#{id}", options, 3
      end

      def remove_hook(repo, id, options={})
        delete "repos/#{Repository.new repo}/hooks/#{id}", options, 3
      end

      def test_hook(repo, id, options={})
        post "repos/#{Repository.new repo}/hooks/#{id}/test", options, 3
      end

      # Get all Issue Events for a given Repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      #
      # @return [Array] Array of all Issue Events for this Repository
      # @see http://developer.github.com/v3/issues/events/#list-events-for-a-repository
      # @example Get all Issue Events for Octokit
      #   Octokit.repository_issue_events("pengwynn/octokit")
      def repository_issue_events(repo, options={})
        get "repos/#{Repository.new repo}/issues/events", options, 3
      end
      alias :repo_issue_events :repository_issue_events

      def repository_assignees(repo, options={})
        get "repos/#{Repository.new repo}/assignees", options, 3
      end
      alias :repo_assignees :repository_assignees
    end
  end
end

module Octokit
  class Client

    # Methods for the Repositories API
    #
    # @see http://developer.github.com/v3/repos/
    module Repositories

      # Check if a repository exists
      #
      # @see http://developer.github.com/v3/repos/#get
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Sawyer::Resource] if a repository exists, false otherwise
      def repository?(repo, options = {})
        repository(repo, options)
      rescue Octokit::NotFound
        false
      end

      # Get a single repository
      #
      # @see http://developer.github.com/v3/repos/#get
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Sawyer::Resource] Repository information
      def repository(repo, options = {})
        get "repos/#{Repository.new repo}", options
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
      # @option options [String] :default_branch Update the default branch for this repository.
      # @return [Sawyer::Resource] Repository information
      def edit_repository(repo, options = {})
        repo = Repository.new(repo)
        options[:name] ||= repo.name
        patch "repos/#{repo}", options
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
      # @return [Array<Sawyer::Resource>] List of repositories
      def repositories(username=nil, options = {})
        if username.nil?
          paginate 'user/repos', options
        else
          paginate "users/#{username}/repos", options
        end
      end
      alias :list_repositories :repositories
      alias :list_repos :repositories
      alias :repos :repositories

      # List all repositories
      #
      # This provides a dump of every repository, in the order that they were
      # created.
      #
      # @see http://developer.github.com/v3/repos/#list-all-repositories
      #
      # @param options [Hash] Optional options
      # @option options [Integer] :since The integer ID of the last Repository
      #   that you’ve seen.
      # @return [Array<Sawyer::Resource>] List of repositories.
      def all_repositories(options = {})
        paginate 'repositories', options
      end

      # Star a repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Boolean] `true` if successfully starred
      # @see http://developer.github.com/v3/activity/starring/#star-a-repository
      def star(repo, options = {})
        boolean_from_response :put, "user/starred/#{Repository.new repo}", options
      end

      # Unstar a repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Boolean] `true` if successfully unstarred
      # @see http://developer.github.com/v3/activity/starring/#unstar-a-repository
      def unstar(repo, options = {})
        boolean_from_response :delete, "user/starred/#{Repository.new repo}", options
      end

      # Watch a repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Boolean] `true` if successfully watched
      # @deprecated Use #star instead
      # @see http://developer.github.com/v3/activity/watching/#watch-a-repository-legacy
      def watch(repo, options = {})
        boolean_from_response :put, "user/watched/#{Repository.new repo}", options
      end

      # Unwatch a repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Boolean] `true` if successfully unwatched
      # @deprecated Use #unstar instead
      # @see http://developer.github.com/v3/activity/watching/#stop-watching-a-repository-legacy
      def unwatch(repo, options = {})
        boolean_from_response :delete, "user/watched/#{Repository.new repo}", options
      end

      # Fork a repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Sawyer::Resource] Repository info for the new fork
      # @see http://developer.github.com/v3/repos/forks/#create-a-fork
      def fork(repo, options = {})
        post "repos/#{Repository.new repo}/forks", options
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
      # @return [Sawyer::Resource] Repository info for the new repository
      # @see http://developer.github.com/v3/repos/#create
      def create_repository(name, options = {})
        organization = options.delete :organization
        options.merge! :name => name

        if organization.nil?
          post 'user/repos', options
        else
          post "orgs/#{organization}/repos", options
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
      def delete_repository(repo, options = {})
        boolean_from_response :delete, "repos/#{Repository.new repo}", options
      end
      alias :delete_repo :delete_repository

      # Hide a public repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Sawyer::Resource] Updated repository info
      def set_private(repo, options = {})
        # GitHub Api for setting private updated to use private attr, rather than public
        update_repository repo, options.merge({ :private => true })
      end

      # Unhide a private repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Sawyer::Resource] Updated repository info
      def set_public(repo, options = {})
        # GitHub Api for setting private updated to use private attr, rather than public
        update_repository repo, options.merge({ :private => false })
      end

      # Get deploy keys on a repo
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Array<Sawyer::Resource>] Array of hashes representing deploy keys.
      # @see http://developer.github.com/v3/repos/keys/#get
      # @example
      #   @client.deploy_keys('octokit/octokit.rb')
      # @example
      #   @client.list_deploy_keys('octokit/octokit.rb')
      def deploy_keys(repo, options = {})
        paginate "repos/#{Repository.new repo}/keys", options
      end
      alias :list_deploy_keys :deploy_keys

      # Add deploy key to a repo
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param title [String] Title reference for the deploy key.
      # @param key [String] Public key.
      # @return [Sawyer::Resource] Hash representing newly added key.
      # @see http://developer.github.com/v3/repos/keys/#create
      # @example
      #    @client.add_deploy_key('octokit/octokit.rb', 'Staging server', 'ssh-rsa AAA...')
      def add_deploy_key(repo, title, key, options = {})
        post "repos/#{Repository.new repo}/keys", options.merge(:title => title, :key => key)
      end

      # Remove deploy key from a repo
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param id [Integer] Id of the deploy key to remove.
      # @return [Boolean] True if key removed, false otherwise.
      # @see http://developer.github.com/v3/repos/keys/#delete
      # @example
      #   @client.remove_deploy_key('octokit/octokit.rb', 100000)
      def remove_deploy_key(repo, id, options = {})
        boolean_from_response :delete, "repos/#{Repository.new repo}/keys/#{id}", options
      end

      # List collaborators
      #
      # Requires authenticated client for private repos.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Array<Sawyer::Resource>] Array of hashes representing collaborating users.
      # @see http://developer.github.com/v3/repos/collaborators/#list
      # @example
      #   Octokit.collaborators('octokit/octokit.rb')
      # @example
      #   Octokit.collabs('octokit/octokit.rb')
      # @example
      #   @client.collabs('octokit/octokit.rb')
      def collaborators(repo, options = {})
        paginate "repos/#{Repository.new repo}/collaborators", options
      end
      alias :collabs :collaborators

      # Add collaborator to repo
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param collaborator [String] Collaborator GitHub username to add.
      # @return [Boolean] True if collaborator added, false otherwise.
      # @see http://developer.github.com/v3/repos/collaborators/#add-collaborator
      # @example
      #   @client.add_collaborator('octokit/octokit.rb', 'holman')
      # @example
      #   @client.add_collab('octokit/octokit.rb', 'holman')
      def add_collaborator(repo, collaborator, options = {})
        boolean_from_response :put, "repos/#{Repository.new repo}/collaborators/#{collaborator}", options
      end
      alias :add_collab :add_collaborator

      # Remove collaborator from repo.
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param collaborator [String] Collaborator GitHub username to remove.
      # @return [Boolean] True if collaborator removed, false otherwise.
      # @see http://developer.github.com/v3/repos/collaborators/#remove-collaborator
      # @example
      #   @client.remove_collaborator('octokit/octokit.rb', 'holman')
      # @example
      #   @client.remove_collab('octokit/octokit.rb', 'holman')
      def remove_collaborator(repo, collaborator, options = {})
        boolean_from_response :delete, "repos/#{Repository.new repo}/collaborators/#{collaborator}", options
      end
      alias :remove_collab :remove_collaborator

      # List teams for a repo
      #
      # Requires authenticated client that is an owner or collaborator of the repo.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Array<Sawyer::Resource>] Array of hashes representing teams.
      # @see http://developer.github.com/v3/repos/#list-teams
      # @example
      #   @client.repository_teams('octokit/pengwynn')
      # @example
      #   @client.repo_teams('octokit/pengwynn')
      # @example
      #   @client.teams('octokit/pengwynn')
      def repository_teams(repo, options = {})
        paginate "repos/#{Repository.new repo}/teams", options
      end
      alias :repo_teams :repository_teams
      alias :teams :repository_teams

      # List contributors to a repo
      #
      # Requires authenticated client for private repos.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param anon [Boolean] Set true to include annonymous contributors.
      # @return [Array<Sawyer::Resource>] Array of hashes representing users.
      # @see http://developer.github.com/v3/repos/#list-contributors
      # @example
      #   Octokit.contributors('octokit/octokit.rb', true)
      # @example
      #   Octokit.contribs('octokit/octokit.rb')
      # @example
      #   @client.contribs('octokit/octokit.rb')
      def contributors(repo, anon = nil, options = {})
        options[:anon] = 1 if anon.to_s[/1|true/]
        paginate "repos/#{Repository.new repo}/contributors", options
      end
      alias :contribs :contributors

      # List stargazers of a repo
      #
      # Requires authenticated client for private repos.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Array<Sawyer::Resource>] Array of hashes representing users.
      # @see http://developer.github.com/v3/repos/starring/#list-stargazers
      # @example
      #   Octokit.stargazers('octokit/octokit.rb')
      # @example
      #   @client.stargazers('octokit/octokit.rb')
      def stargazers(repo, options = {})
        paginate "repos/#{Repository.new repo}/stargazers", options
      end

      # @deprecated Use {#stargazers} instead
      #
      # List watchers of repo.
      #
      # Requires authenticated client for private repos.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Array<Sawyer::Resource>] Array of hashes representing users.
      # @see http://developer.github.com/v3/repos/watching/#list-watchers
      # @example
      #   Octokit.watchers('octokit/octokit.rb')
      # @example
      #   @client.watchers('octokit/octokit.rb')
      def watchers(repo, options = {})
        paginate "repos/#{Repository.new repo}/watchers", options
      end

      # List forks
      #
      # Requires authenticated client for private repos.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Array<Sawyer::Resource>] Array of hashes representing repos.
      # @see http://developer.github.com/v3/repos/forks/#list-forks
      # @example
      #   Octokit.forks('octokit/octokit.rb')
      # @example
      #   Octokit.network('octokit/octokit.rb')
      # @example
      #   @client.forks('octokit/octokit.rb')
      def forks(repo, options = {})
        paginate "repos/#{Repository.new repo}/forks", options
      end
      alias :network :forks

      # List languages of code in the repo.
      #
      # Requires authenticated client for private repos.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Array<Sawyer::Resource>] Array of Hashes representing languages.
      # @see http://developer.github.com/v3/repos/#list-languages
      # @example
      #   Octokit.langauges('octokit/octokit.rb')
      # @example
      #   @client.languages('octokit/octokit.rb')
      def languages(repo, options = {})
        paginate "repos/#{Repository.new repo}/languages", options
      end

      # List tags
      #
      # Requires authenticated client for private repos.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Array<Sawyer::Resource>] Array of hashes representing tags.
      # @see http://developer.github.com/v3/repos/#list-tags
      # @example
      #   Octokit.tags('octokit/octokit.rb')
      # @example
      #   @client.tags('octokit/octokit.rb')
      def tags(repo, options = {})
        paginate "repos/#{Repository.new repo}/tags", options
      end

      # List branches
      #
      # Requires authenticated client for private repos.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Array<Sawyer::Resource>] Array of hashes representing branches.
      # @see http://developer.github.com/v3/repos/#list-branches
      # @example
      #   Octokit.branches('octokit/octokit.rb')
      # @example
      #   @client.branches('octokit/octokit.rb')
      def branches(repo, options = {})
        paginate "repos/#{Repository.new repo}/branches", options
      end

      # Get a single branch from a repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param branch [String] Branch name
      # @return [Sawyer::Resource] The branch requested, if it exists
      # @see http://developer.github.com/v3/repos/#get-branch
      # @example Get branch 'master` from octokit/octokit.rb
      #   Octokit.branch("octokit/octokit.rb", "master")
      def branch(repo, branch, options = {})
        get "repos/#{Repository.new repo}/branches/#{branch}", options
      end
      alias :get_branch :branch

      # List repo hooks
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Array<Sawyer::Resource>] Array of hashes representing hooks.
      # @see http://developer.github.com/v3/repos/hooks/#list
      # @example
      #   @client.hooks('octokit/octokit.rb')
      def hooks(repo, options = {})
        paginate "repos/#{Repository.new repo}/hooks", options
      end

      # Get single hook
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param id [Integer] Id of the hook to get.
      # @return [Sawyer::Resource] Hash representing hook.
      # @see http://developer.github.com/v3/repos/hooks/#get-single-hook
      # @example
      #   @client.hook('octokit/octokit.rb', 100000)
      def hook(repo, id, options = {})
        get "repos/#{Repository.new repo}/hooks/#{id}", options
      end

      # Create a hook
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param name [String] The name of the service that is being called. See
      #   {https://api.github.com/hooks Hooks} for the possible names.
      # @param config [Hash] A Hash containing key/value pairs to provide
      #   settings for this hook. These settings vary between the services and
      #   are defined in the {https://github.com/github/github-services github-services} repo.
      # @option options [Array<String>] :events ('["push"]') Determines what
      #   events the hook is triggered for.
      # @option options [Boolean] :active Determines whether the hook is
      #   actually triggered on pushes.
      # @return [Sawyer::Resource] Hook info for the new hook
      # @see https://api.github.com/hooks
      # @see https://github.com/github/github-services
      # @see http://developer.github.com/v3/repos/hooks/#create-a-hook
      # @example
      #   @client.create_hook(
      #     'octokit/octokit.rb',
      #     'web',
      #     {
      #       :url => 'http://something.com/webhook',
      #       :content_type => 'json'
      #     },
      #     {
      #       :events => ['push', 'pull_request'],
      #       :active => true
      #     }
      #   )
      def create_hook(repo, name, config, options = {})
        options = {:name => name, :config => config, :events => ["push"], :active => true}.merge(options)
        post "repos/#{Repository.new repo}/hooks", options
      end

      # Edit a hook
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param id [Integer] Id of the hook being updated.
      # @param name [String] The name of the service that is being called. See
      #   {https://api.github.com/hooks Hooks} for the possible names.
      # @param config [Hash] A Hash containing key/value pairs to provide
      #   settings for this hook. These settings vary between the services and
      #   are defined in the {https://github.com/github/github-services github-services} repo.
      # @option options [Array<String>] :events ('["push"]') Determines what
      #   events the hook is triggered for.
      # @option options [Array<String>] :add_events Determines a list of events
      #   to be added to the list of events that the Hook triggers for.
      # @option options [Array<String>] :remove_events Determines a list of events
      #   to be removed from the list of events that the Hook triggers for.
      # @option options [Boolean] :active Determines whether the hook is
      #   actually triggered on pushes.
      # @return [Sawyer::Resource] Hook info for the updated hook
      # @see https://api.github.com/hooks
      # @see https://github.com/github/github-services
      # @see http://developer.github.com/v3/repos/hooks/#edit-a-hook
      # @example
      #   @client.edit_hook(
      #     'octokit/octokit.rb',
      #     100000,
      #     'web',
      #     {
      #       :url => 'http://something.com/webhook',
      #       :content_type => 'json'
      #     },
      #     {
      #       :add_events => ['status'],
      #       :remove_events => ['pull_request'],
      #       :active => true
      #     }
      #   )
      def edit_hook(repo, id, name, config, options = {})
        options = {:name => name, :config => config, :events => ["push"], :active => true}.merge(options)
        patch "repos/#{Repository.new repo}/hooks/#{id}", options
      end

      # Delete hook
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param id [Integer] Id of the hook to remove.
      # @return [Boolean] True if hook removed, false otherwise.
      # @see http://developer.github.com/v3/repos/hooks/#delete-a-hook
      # @example
      #   @client.remove_hook('octokit/octokit.rb', 1000000)
      def remove_hook(repo, id, options = {})
        boolean_from_response :delete, "repos/#{Repository.new repo}/hooks/#{id}", options
      end

      # Test hook
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param id [Integer] Id of the hook to test.
      # @return [Boolean] Success
      # @see http://developer.github.com/v3/repos/hooks/#test-a-hook
      # @example
      #   @client.test_hook('octokit/octokit.rb', 1000000)
      def test_hook(repo, id, options = {})
        boolean_from_response :post, "repos/#{Repository.new repo}/hooks/#{id}/tests", options
      end

      # List users available for assigning to issues.
      #
      # Requires authenticated client for private repos.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Array<Sawyer::Resource>] Array of hashes representing users.
      # @see http://developer.github.com/v3/issues/assignees/#list-assignees
      # @example
      #   Octokit.repository_assignees('octokit/octokit.rb')
      # @example
      #   Octokit.repo_assignees('octokit/octokit.rb')
      # @example
      #   @client.repository_assignees('octokit/octokit.rb')
      def repository_assignees(repo, options = {})
        paginate "repos/#{Repository.new repo}/assignees", options
      end
      alias :repo_assignees :repository_assignees

      # Check to see if a particular user is an assignee for a repository.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param assignee [String] User login to check
      # @return [Boolean] True if assignable on project, false otherwise.
      # @see http://developer.github.com/v3/issues/assignees/#check-assignee
      # @example
      #   Octokit.check_assignee('octokit/octokit.rb', 'andrew')
      def check_assignee(repo, assignee, options = {})
        boolean_from_response :get, "repos/#{Repository.new repo}/assignees/#{assignee}", options
      end

      # List watchers subscribing to notifications for a repo
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Array<Sawyer::Resource>] Array of users watching.
      # @see http://developer.github.com/v3/activity/watching/#list-watchers
      # @example
      #   @client.subscribers("octokit/octokit.rb")
      def subscribers(repo, options = {})
        paginate "repos/#{Repository.new repo}/subscribers", options
      end

      # Get a repository subscription
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Sawyer::Resource] Repository subscription.
      # @see http://developer.github.com/v3/activity/watching/#get-a-repository-subscription
      # @example
      #   @client.subscription("octokit/octokit.rb")
      def subscription(repo, options = {})
        get "repos/#{Repository.new repo}/subscription", options
      end

      # Update repository subscription
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param options [Hash]
      #
      # @option options [Boolean] :subscribed Determines if notifications
      #   should be received from this repository.
      # @option options [Boolean] :ignored Deterimines if all notifications
      #   should be blocked from this repository.
      # @return [Sawyer::Resource] Updated repository subscription.
      # @see http://developer.github.com/v3/activity/watching/#set-a-repository-subscription
      # @example Subscribe to notifications for a repository
      #   @client.update_subscription("octokit/octokit.rb", {subscribed: true})
      def update_subscription(repo, options = {})
        put "repos/#{Repository.new repo}/subscription", options
      end

      # Delete a repository subscription
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Boolean] True if subscription deleted, false otherwise.
      # @see http://developer.github.com/v3/activity/watching/#delete-a-repository-subscription
      #
      # @example
      #   @client.delete_subscription("octokit/octokit.rb")
      def delete_subscription(repo, options = {})
        boolean_from_response :delete, "repos/#{Repository.new repo}/subscription", options
      end
    end
  end
end

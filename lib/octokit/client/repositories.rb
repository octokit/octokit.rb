module Octokit
  class Client
    module Repositories

      # Legacy repository search
      #
      # @see http://developer.github.com/v3/search/#search-repositories
      # @param q [String] Search keyword
      # @return [Array<Hashie::Mash>] List of repositories found
      def search_repositories(keyword, options={})
        options.merge! :keyword => keyword
        root.rels[:repository_search].get(:uri => options).data.repositories
      end
      alias :search_repos :search_repositories

      # Get a single repository
      #
      # @see http://developer.github.com/v3/repos/#get
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Hashie::Mash] Repository information
      def repository(repo, options={})
        repo = Repository.new(repo)
        root.rels[:repository].get(:uri => {:owner => repo.user, :repo => repo.name}).data
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
      # @return [Hashie::Mash] Repository information
      def edit_repository(repo, options={})
        repository(repo).rels[:self].patch(options).data
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
        user(username).rels[:repos].get(options).data
      end
      alias :list_repositories :repositories
      alias :list_repos :repositories
      alias :repos :repositories

      # Star a repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Boolean] `true` if successfully starred
      def star(repo, options={})
        repo = Repository.new(repo)
        uri_options = { :uri => { :owner => repo.owner, :repo => repo.name } }
        root.rels[:starred].put(nil, uri_options).status == 204
      end

      # Unstar a repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Boolean] `true` if successfully unstarred
      def unstar(repo, options={})
        repo = Repository.new(repo)
        uri_options = { :uri => { :owner => repo.owner, :repo => repo.name } }
        root.rels[:starred].delete(nil, uri_options).status == 204
      end

      # Fork a repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Hashie::Mash] Repository info for the new fork
      def fork(repo, options={})
        repository(repo).rels[:forks].post(options).data
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
        org_name = options.delete :organization
        options.merge! :name => name

        if org_name.nil?
          root.rels[:current_user_repositories].post(options).data
        else
          organization(org_name).rels[:repositories].post(options).data
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
        repository(repo).rels[:self].delete(options).status == 204
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

      # Get deploy keys on a repo
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Array<Hashie::Mash>] Array of hashes representing deploy keys.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/repos/keys/#get
      # @example
      #   @client.deploy_keys('pengwynn/octokit')
      # @example
      #   @client.list_deploy_keys('pengwynn/octokit')
      def deploy_keys(repo, options={})
        repository(repo).rels[:keys].get(options).data
      end
      alias :list_deploy_keys :deploy_keys

      # Add deploy key to a repo
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param title [String] Title reference for the deploy key.
      # @param key [String] Public key.
      # @return [Hashie::Mash] Hash representing newly added key.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/repos/keys/#create
      # @example
      #    @client.add_deploy_key('pengwynn/octokit', 'Staging server', 'ssh-rsa AAA...')
      def add_deploy_key(repo, title, key, options={})
        options.merge! :title => title, :key => key
        repository(repo).rels[:keys].post(options).data
      end

      # Remove deploy key from a repo
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param id [Integer] Id of the deploy key to remove.
      # @return [Boolean] True if key removed, false otherwise.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/repos/keys/#delete
      # @example
      #   @client.remove_deploy_key('pengwynn/octokit', 100000)
      def remove_deploy_key(repo, id, options={})
        uri_options = { :uri => { :key_id => id } }
        repository(repo).rels[:keys].delete(options, uri_options).status == 204
      end

      # List collaborators
      #
      # Requires authenticated client for private repos.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Array<Hashie::Mash>] Array of hashes representing collaborating users.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/repos/collaborators/#list
      # @example
      #   Octokit.collaborators('pengwynn/octokit')
      # @example
      #   Octokit.collabs('pengwynn/octokit')
      # @example
      #   @client.collabs('pengwynn/octokit')
      def collaborators(repo, options={})
        repository(repo).rels[:collaborators].get(options).data
      end
      alias :collabs :collaborators

      # Add collaborator to repo
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param collaborator [String] Collaborator GitHub username to add.
      # @return [Boolean] True if collaborator added, false otherwise.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/repos/collaborators/#add-collaborator
      # @example
      #   @client.add_collaborator('pengwynn/octokit', 'holman')
      # @example
      #   @client.add_collab('pengwynn/octokit', 'holman')
      def add_collaborator(repo, collaborator, options={})
        uri_options = { :uri => {:collaborator => collaborator } }
        repository(repo).rels[:collaborators].put(options, uri_options).status == 204
      end
      alias :add_collab :add_collaborator

      # Remove collaborator from repo.
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param collaborator [String] Collaborator GitHub username to remove.
      # @return [Boolean] True if collaborator removed, false otherwise.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/repos/collaborators/#remove-collaborator
      # @example
      #   @client.remove_collaborator('pengwynn/octokit', 'holman')
      # @example
      #   @client.remove_collab('pengwynn/octokit', 'holman')
      def remove_collaborator(repo, collaborator, options={})
        uri_options = { :uri => {:collaborator => collaborator } }
        repository(repo).rels[:collaborators].delete(options, uri_options).status == 204
      end
      alias :remove_collab :remove_collaborator

      # List teams for a repo
      #
      # Requires authenticated client that is an owner or collaborator of the repo.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Array<Hashie::Mash>] Array of hashes representing teams.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/repos/#list-teams
      # @example
      #   @client.repository_teams('octokit/pengwynn')
      # @example
      #   @client.repo_teams('octokit/pengwynn')
      # @example
      #   @client.teams('octokit/pengwynn')
      def repository_teams(repo, options={})
        repository(repo).rels[:teams].get(options).data
      end
      alias :repo_teams :repository_teams
      alias :teams :repository_teams

      # List contributors to a repo
      #
      # Requires authenticated client for private repos.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param anon [Boolean] Set true to include annonymous contributors.
      # @return [Array<Hashie::Mash>] Array of hashes representing users.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/repos/#list-contributors
      # @example
      #   Octokit.contributors('pengwynn/octokit', true)
      # @example
      #   Octokit.contribs('pengwynn/octokit')
      # @example
      #   @client.contribs('pengwynn/octokit')
      def contributors(repo, anon=false, options={})
        options.merge! :query => {:anon => anon.to_s}
        repository(repo).rels[:contributors].get(options).data
      end
      alias :contribs :contributors

      # List stargazers of a repo
      #
      # Requires authenticated client for private repos.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Array<Hashie::Mash>] Array of hashes representing users.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/repos/starring/#list-stargazers
      # @example
      #   Octokit.stargazers('pengwynn/octokit')
      # @example
      #   @client.stargazers('pengwynn/octokit')
      def stargazers(repo, options={})
        repository(repo).rels[:stargazers].get(options).data
      end

      # List forks
      #
      # Requires authenticated client for private repos.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Array<Hashie::Mash>] Array of hashes representing repos.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/repos/forks/#list-forks
      # @example
      #   Octokit.forks('pengwynn/octokit')
      # @example
      #   Octokit.network('pengwynn/octokit')
      # @example
      #   @client.forks('pengwynn/octokit')
      def forks(repo, options={})
        repository(repo).rels[:forks].get(options).data
      end
      alias :network :forks

      # List languages of code in the repo.
      #
      # Requires authenticated client for private repos.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Array<Hashie::Mash>] Array of Hashes representing languages.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/repos/#list-languages
      # @example
      #   Octokit.langauges('pengwynn/octokit')
      # @example
      #   @client.languages('pengwynn/octokit')
      def languages(repo, options={})
        repository(repo).rels[:languages].get(options).data
      end

      # List tags
      #
      # Requires authenticated client for private repos.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Array<Hashie::Mash>] Array of hashes representing tags.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/repos/#list-tags
      # @example
      #   Octokit.tags('pengwynn/octokit')
      # @example
      #   @client.tags('pengwynn/octokit')
      def tags(repo, options={})
        repository(repo).rels[:tags].get(options).data
      end

      # List branches
      #
      # Requires authenticated client for private repos.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Array<Hashie::Mash>] Array of hashes representing branches.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/repos/#list-branches
      # @example
      #   Octokit.branches('pengwynn/octokit')
      # @example
      #   @client.branches('pengwynn/octokit')
      def branches(repo, options={})
        repository(repo).rels[:branches].get(options).data
      end

      # Get a single branch from a repository
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param branch [String] Branch name
      # @return [Branch] The branch requested, if it exists
      # @see http://developer.github.com/v3/repos/#get-branch
      # @example Get branch 'master` from pengwynn/octokit
      #   Octokit.issue("pengwynn/octokit", "master")
      def branch(repo, branch, options={})
        options.merge! :uri => { :branch => branch }
        repository(repo).rels[:branches].get(options).data
      end
      alias :get_branch :branch

      # List repo hooks
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Array<Hashie::Mash>] Array of hashes representing hooks.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/repos/hooks/#list
      # @example
      #   @client.hooks('pengwynn/octokit')
      def hooks(repo, options={})
        repository(repo).rels[:hooks].get(options).data
      end

      # Get single hook
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param id [Integer] Id of the hook to get.
      # @return [Hashie::Mash] Hash representing hook.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/repos/hooks/#get-single-hook
      # @example
      #   @client.hook('pengwynn/octokit', 100000)
      def hook(repo, id, options={})
        options.merge! :uri => { :hook_id => id }
        repository(repo).rels[:hooks].get(options).data
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
      # @see Octokit::Client
      # @see https://api.github.com/hooks
      # @see https://github.com/github/github-services
      # @see http://developer.github.com/v3/repos/hooks/#create-a-hook
      # @example
      #   @client.create_hook(
      #     'pengwynn/octokit',
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
      def create_hook(repo, name, config, options={})
        options = {:name => name, :config => config, :events => ["push"], :active => true}.merge(options)
        repository(repo).rels[:hooks].post(options).data
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
      # @see Octokit::Client
      # @see https://api.github.com/hooks
      # @see https://github.com/github/github-services
      # @see http://developer.github.com/v3/repos/hooks/#edit-a-hook
      # @example
      #   @client.edit_hook(
      #     'pengwynn/octokit',
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
      def edit_hook(repo, id, name, config, options={})
        options = {:name => name, :config => config, :events => ["push"], :active => true}.merge(options)
        repository(repo).rels[:hooks].patch(options, :uri => { :hook_id => id }).data
      end

      # Delete hook
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param id [Integer] Id of the hook to remove.
      # @return [Boolean] True if hook removed, false otherwise.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/repos/hooks/#delete-a-hook
      # @example
      #   @client.remove_hook('pengwynn/octokit', 1000000)
      def remove_hook(repo, id, options={})
        repository(repo).rels[:hooks].delete(options, :uri => {:hook_id => id}).data
      end

      # Test hook
      #
      # Requires authenticated client.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param id [Integer] Id of the hook to test.
      # @return [nil]
      # @see Octokit::Client
      # @see http://developer.github.com/v3/repos/hooks/#test-a-hook
      # @example
      #   @client.test_hook('pengwynn/octokit', 1000000)
      def test_hook(repo, id, options={})
        hook(repo, id).rels[:test].post(options).data
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
        repository(repo).rels[:issue_events].get(options).data
      end
      alias :repo_issue_events :repository_issue_events

      # List users available for assigning to issues.
      #
      # Requires authenticated client for private repos.
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @returns [Array<Hashie::Mash>] Array of hashes representing users.
      # @see Octokit::Client
      # @see http://developer.github.com/v3/issues/assignees/#list-assignees
      # @example
      #   Octokit.repository_assignees('pengwynn/octokit')
      # @example
      #   Octokit.repo_assignees('pengwynn/octokit')
      # @example
      #   @client.repository_assignees('pengwynn/octokit')
      def repository_assignees(repo, options={})
        repository(repo).rels[:assignees].get(options).data
      end
      alias :repo_assignees :repository_assignees

      # List watchers subscribing to notifications for a repo
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      #
      # @return [Array] Array of users watching.
      #
      # @see http://developer.github.com/v3/activity/watching/#list-watchers
      #
      # @example
      #   @client.subscribers("pengwynn/octokit")
      def subscribers(repo, options={})
        repository(repo).rels[:subscribers].get(options).data
      end

      # Get a repository subscription
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      #
      # @return [Hashie::Mash] Repository subscription.
      #
      # @see http://developer.github.com/v3/activity/watching/#get-a-repository-subscription
      #
      # @example
      #   @client.subscription("pengwynn/octokit")
      def subscription(repo, options={})
        repository(repo).rels[:subscription].get(options).data
      end

      # Update repository subscription
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param options [Hash]
      #
      # @option options [Boolean] :subscribed Determines if notifications
      #   should be received from this repository.
      #
      # @option options [Boolean] :ignored Deterimines if all notifications
      #   should be blocked from this repository.
      #
      # @return [Hashie::Mash] Updated repository subscription.
      #
      # @see http://developer.github.com/v3/activity/watching/#set-a-repository-subscription
      #
      # @example Subscribe to notifications for a repository
      #   @client.update_subscription("pengwynn/octokit", {subscribed: true})
      def update_subscription(repo, options={})
        repository(repo).rels[:subscription].put(options).data
      end

      # Delete a repository subscription
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      #
      # @return [Boolean] True if subscription deleted, false otherwise.
      #
      # @see http://developer.github.com/v3/activity/watching/#delete-a-repository-subscription
      #
      # @example
      #   @client.delete_subscription("pengwynn/octokit")
      def delete_subscription(repo, options={})
        repository(repo).rels[:subscription].delete(options).status == 204
      end

    end
  end
end

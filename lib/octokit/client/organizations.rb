module Octokit
  class Client

    # Methods for the Organizations API
    #
    # @see https://developer.github.com/v3/orgs/
    module Organizations

      ORG_INVITATIONS_PREVIEW_MEDIA_TYPE = "application/vnd.github.the-wasp-preview+json".freeze

      # Get an organization
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @return [Sawyer::Resource] Hash representing GitHub organization.
      # @see https://developer.github.com/v3/orgs/#get-an-organization
      # @example
      #   Octokit.organization('github')
      # @example
      #   Octokit.org('github')
      def organization(org, options = {})
        get Organization.path(org), options
      end
      alias :org :organization

      # Update an organization.
      #
      # Requires authenticated client with proper organization permissions.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @param values [Hash] The updated organization attributes.
      # @option values [String] :billing_email Billing email address. This address is not publicized.
      # @option values [String] :company Company name.
      # @option values [String] :email Publicly visible email address.
      # @option values [String] :location Location of organization.
      # @option values [String] :name GitHub username for organization.
      # @return [Sawyer::Resource] Hash representing GitHub organization.
      # @see https://developer.github.com/v3/orgs/#edit-an-organization
      # @example
      #   @client.update_organization('github', {
      #     :billing_email => 'support@github.com',
      #     :company => 'GitHub',
      #     :email => 'support@github.com',
      #     :location => 'San Francisco',
      #     :name => 'github'
      #   })
      # @example
      #   @client.update_org('github', {:company => 'Unicorns, Inc.'})
      def update_organization(org, values, options = {})
        patch Organization.path(org), options.merge({:organization => values})
      end
      alias :update_org :update_organization

      # Get organizations for a user.
      #
      # Nonauthenticated calls to this method will return organizations that
      # the user is a public member.
      #
      # Use an authenicated client to get both public and private organizations
      # for a user.
      #
      # Calling this method on a `@client` will return that users organizations.
      # Private organizations are included only if the `@client` is authenticated.
      #
      # @param user [Integer, String] GitHub user login or id of the user to get
      #   list of organizations.
      # @return [Array<Sawyer::Resource>] Array of hashes representing organizations.
      # @see https://developer.github.com/v3/orgs/#list-user-organizations
      # @example
      #   Octokit.organizations('pengwynn')
      # @example
      #   @client.organizations('pengwynn')
      # @example
      #   Octokit.orgs('pengwynn')
      # @example
      #   Octokit.list_organizations('pengwynn')
      # @example
      #   Octokit.list_orgs('pengwynn')
      # @example
      #   @client.organizations
      def organizations(user=nil, options = {})
        get "#{User.path user}/orgs", options
      end
      alias :list_organizations :organizations
      alias :list_orgs :organizations
      alias :orgs :organizations

      # List organization repositories
      #
      # Public repositories are available without authentication. Private repos
      # require authenticated organization member.
      #
      # @param org [String, Integer] Organization GitHub login or id for which
      #   to list repos.
      # @option options [String] :type ('all') Filter by repository type.
      #   `all`, `public`, `member`, `sources`, `forks`, or `private`.
      #
      # @return [Array<Sawyer::Resource>] List of repositories
      # @see https://developer.github.com/v3/repos/#list-organization-repositories
      # @example
      #   Octokit.organization_repositories('github')
      # @example
      #   Octokit.org_repositories('github')
      # @example
      #   Octokit.org_repos('github')
      # @example
      #   @client.org_repos('github', {:type => 'private'})
      def organization_repositories(org, options = {})
        paginate "#{Organization.path org}/repos", options
      end
      alias :org_repositories :organization_repositories
      alias :org_repos :organization_repositories

      # Get organization members
      #
      # Public members of the organization are returned by default. An
      # authenticated client that is a member of the GitHub organization
      # is required to get private members.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @return [Array<Sawyer::Resource>] Array of hashes representing users.
      # @see https://developer.github.com/v3/orgs/members/#members-list
      # @example
      #   Octokit.organization_members('github')
      # @example
      #   Octokit.org_members('github')
      def organization_members(org, options = {})
        path = "public_" if options.delete(:public)
        paginate "#{Organization.path org}/#{path}members", options
      end
      alias :org_members :organization_members

      # Get organization public members
      #
      # Lists the public members of an organization
      #
      # @param org [String] Organization GitHub username.
      # @return [Array<Sawyer::Resource>] Array of hashes representing users.
      # @see https://developer.github.com/v3/orgs/members/#public-members-list
      # @example
      #   Octokit.organization_public_members('github')
      # @example
      #   Octokit.org_public_members('github')
      def organization_public_members(org, options = {})
        organization_members org, options.merge(:public => true)
      end
      alias :org_public_members :organization_public_members

      # Check if a user is a member of an organization.
      #
      # Use this to check if another user is a member of an organization that
      # you are a member. If you are not in the organization you are checking,
      # use .organization_public_member? instead.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @param user [String] GitHub username of the user to check.
      #
      # @return [Boolean] Is a member?
      #
      # @see https://developer.github.com/v3/orgs/members/#check-membership
      #
      # @example Check if a user is in your organization
      #   @client.organization_member?('your_organization', 'pengwynn')
      #   => false
      def organization_member?(org, user, options = {})
        result = boolean_from_response(:get, "#{Organization.path org}/members/#{user}", options)
        if !result && last_response && last_response.status == 302
          boolean_from_response :get, last_response.headers['Location']
        else
          result
        end
      end
      alias :org_member? :organization_member?

      # Check if a user is a public member of an organization.
      #
      # If you are checking for membership of a user of an organization that
      # you are in, use .organization_member? instead.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @param user [String] GitHub username of the user to check.
      #
      # @return [Boolean] Is a public member?
      #
      # @see https://developer.github.com/v3/orgs/members/#check-public-membership
      #
      # @example Check if a user is a hubbernaut
      #   @client.organization_public_member?('github', 'pengwynn')
      #   => true
      def organization_public_member?(org, user, options = {})
        boolean_from_response :get, "#{Organization.path org}/public_members/#{user}", options
      end
      alias :org_public_member? :organization_public_member?

      # List teams
      #
      # Requires authenticated organization member.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @return [Array<Sawyer::Resource>] Array of hashes representing teams.
      # @see https://developer.github.com/v3/orgs/teams/#list-teams
      # @example
      #   @client.organization_teams('github')
      # @example
      #   @client.org_teams('github')
      def organization_teams(org, options = {})
        paginate "#{Organization.path org}/teams", options
      end
      alias :org_teams :organization_teams

      # Create team
      #
      # Requires authenticated organization owner.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @option options [String] :name Team name.
      # @option options [Array<String>] :repo_names Repositories for the team.
      # @option options [String, optional] :permission ('pull') Permissions the
      #   team has for team repositories.
      #
      #   `pull` - team members can pull, but not push to or administer these repositories.
      #   `push` - team members can pull and push, but not administer these repositories.
      #   `admin` - team members can pull, push and administer these repositories.
      # @return [Sawyer::Resource] Hash representing new team.
      # @see https://developer.github.com/v3/orgs/teams/#create-team
      # @example
      #   @client.create_team('github', {
      #     :name => 'Designers',
      #     :repo_names => ['github/dotfiles'],
      #     :permission => 'push'
      #   })
      def create_team(org, options = {})
        post "#{Organization.path org}/teams", options
      end

      # Get team
      #
      # Requires authenticated organization member.
      #
      # @param team_id [Integer] Team id.
      # @return [Sawyer::Resource] Hash representing team.
      # @see https://developer.github.com/v3/orgs/teams/#get-team
      # @example
      #   @client.team(100000)
      def team(team_id, options = {})
        get "teams/#{team_id}", options
      end

      # Update team
      #
      # Requires authenticated organization owner.
      #
      # @param team_id [Integer] Team id.
      # @option options [String] :name Team name.
      # @option options [String] :permission Permissions the team has for team repositories.
      #
      #   `pull` - team members can pull, but not push to or administer these repositories.
      #   `push` - team members can pull and push, but not administer these repositories.
      #   `admin` - team members can pull, push and administer these repositories.
      # @return [Sawyer::Resource] Hash representing updated team.
      # @see https://developer.github.com/v3/orgs/teams/#edit-team
      # @example
      #   @client.update_team(100000, {
      #     :name => 'Front-end Designers',
      #     :permission => 'push'
      #   })
      def update_team(team_id, options = {})
        patch "teams/#{team_id}", options
      end

      # Delete team
      #
      # Requires authenticated organization owner.
      #
      # @param team_id [Integer] Team id.
      # @return [Boolean] True if deletion successful, false otherwise.
      # @see https://developer.github.com/v3/orgs/teams/#delete-team
      # @example
      #   @client.delete_team(100000)
      def delete_team(team_id, options = {})
        boolean_from_response :delete, "teams/#{team_id}", options
      end

      # List team members
      #
      # Requires authenticated organization member.
      #
      # @param team_id [Integer] Team id.
      # @return [Array<Sawyer::Resource>] Array of hashes representing users.
      # @see https://developer.github.com/v3/orgs/teams/#list-team-members
      # @example
      #   @client.team_members(100000)
      def team_members(team_id, options = {})
        paginate "teams/#{team_id}/members", options
      end

      # Add team member
      #
      # Requires authenticated organization owner or member with team
      # `admin` permission.
      #
      # @param team_id [Integer] Team id.
      # @param user [String] GitHub username of new team member.
      # @return [Boolean] True on successful addition, false otherwise.
      # @see https://developer.github.com/v3/orgs/teams/#add-team-member
      # @example
      #   @client.add_team_member(100000, 'pengwynn')
      #
      # @example
      #   # Invite a member to a team. The user won't be added to the 
      #   # team until he/she accepts the invite via email.
      #   @client.add_team_member \
      #     100000,
      #     'pengwynn',
      #     :accept => "application/vnd.github.the-wasp-preview+json"
      # @see https://developer.github.com/changes/2014-08-05-team-memberships-api/
      def add_team_member(team_id, user, options = {})
        # There's a bug in this API call. The docs say to leave the body blank,
        # but it fails if the body is both blank and the content-length header
        # is not 0.
        boolean_from_response :put, "teams/#{team_id}/members/#{user}", options.merge({:name => user})
      end

      # Remove team member
      #
      # Requires authenticated organization owner or member with team
      # `admin` permission.
      #
      # @param team_id [Integer] Team id.
      # @param user [String] GitHub username of the user to boot.
      # @return [Boolean] True if user removed, false otherwise.
      # @see https://developer.github.com/v3/orgs/teams/#remove-team-member
      # @example
      #   @client.remove_team_member(100000, 'pengwynn')
      def remove_team_member(team_id, user, options = {})
        boolean_from_response :delete, "teams/#{team_id}/members/#{user}", options
      end

      # Check if a user is a member of a team.
      #
      # Use this to check if another user is a member of a team that
      # you are a member.
      #
      # @param team_id [Integer] Team id.
      # @param user [String] GitHub username of the user to check.
      #
      # @return [Boolean] Is a member?
      #
      # @see https://developer.github.com/v3/orgs/teams/#get-team-member
      #
      # @example Check if a user is in your team
      #   @client.team_member?('your_team', 'pengwynn')
      #   => false
      def team_member?(team_id, user, options = {})
        boolean_from_response :get, "teams/#{team_id}/members/#{user}", options
      end

      # List team repositories
      #
      # Requires authenticated organization member.
      #
      # @param team_id [Integer] Team id.
      # @return [Array<Sawyer::Resource>] Array of hashes representing repositories.
      # @see https://developer.github.com/v3/orgs/teams/#list-team-repos
      # @example
      #   @client.team_repositories(100000)
      # @example
      #   @client.team_repos(100000)
      def team_repositories(team_id, options = {})
        paginate "teams/#{team_id}/repos", options
      end
      alias :team_repos :team_repositories

      # Check if a repo is managed by a specific team
      #
      # @param team_id [Integer] Team ID.
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Boolean] True if managed by a team. False if not managed by
      #   the team OR the requesting user does not have authorization to access
      #   the team information.
      # @see https://developer.github.com/v3/orgs/teams/#get-team-repo
      # @example
      #   @client.team_repository?(8675309, 'octokit/octokit.rb')
      # @example
      #   @client.team_repo?(8675309, 'octokit/octokit.rb')
      def team_repository?(team_id, repo, options = {})
        boolean_from_response :get, "teams/#{team_id}/repos/#{Repository.new(repo)}"
      end
      alias :team_repo? :team_repository?

      # Add team repository
      #
      # Requires authenticated user to be an owner of the organization that the
      # team is associated with. Also, the repo must be owned by the
      # organization, or a direct form of a repo owned by the organization.
      #
      # @param team_id [Integer] Team id.
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Boolean] True if successful, false otherwise.
      # @see Octokit::Repository
      # @see https://developer.github.com/v3/orgs/teams/#add-team-repo
      # @example
      #   @client.add_team_repository(100000, 'github/developer.github.com')
      # @example
      #   @client.add_team_repo(100000, 'github/developer.github.com')
      def add_team_repository(team_id, repo, options = {})
        boolean_from_response :put, "teams/#{team_id}/repos/#{Repository.new(repo)}", options.merge(:name => Repository.new(repo))
      end
      alias :add_team_repo :add_team_repository

      # Remove team repository
      #
      # Removes repository from team. Does not delete the repository.
      #
      # Requires authenticated organization owner.
      #
      # @param team_id [Integer] Team id.
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Boolean] Return true if repo removed from team, false otherwise.
      # @see Octokit::Repository
      # @see https://developer.github.com/v3/orgs/teams/#remove-team-repo
      # @example
      #   @client.remove_team_repository(100000, 'github/developer.github.com')
      # @example
      #   @client.remove_team_repo(100000, 'github/developer.github.com')
      def remove_team_repository(team_id, repo, options = {})
        boolean_from_response :delete, "teams/#{team_id}/repos/#{Repository.new(repo)}"
      end
      alias :remove_team_repo :remove_team_repository

      # Remove organization member
      #
      # Requires authenticated organization owner or member with team `admin` access.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @param user [String] GitHub username of user to remove.
      # @return [Boolean] True if removal is successful, false otherwise.
      # @see https://developer.github.com/v3/orgs/members/#remove-a-member
      # @example
      #   @client.remove_organization_member('github', 'pengwynn')
      # @example
      #   @client.remove_org_member('github', 'pengwynn')
      def remove_organization_member(org, user, options = {})
        # this is a synonym for: for team in org.teams: remove_team_member(team.id, user)
        # provided in the GH API v3
        boolean_from_response :delete, "#{Organization.path org}/members/#{user}", options
      end
      alias :remove_org_member :remove_organization_member

      # Publicize a user's membership of an organization
      #
      # Requires authenticated organization owner.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @param user [String] GitHub username of user to publicize.
      # @return [Boolean] True if publicization successful, false otherwise.
      # @see https://developer.github.com/v3/orgs/members/#publicize-a-users-membership
      # @example
      #   @client.publicize_membership('github', 'pengwynn')
      def publicize_membership(org, user, options = {})
        boolean_from_response :put, "#{Organization.path org}/public_members/#{user}", options
      end

      # Conceal a user's membership of an organization.
      #
      # Requires authenticated organization owner.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @param user [String] GitHub username of user to unpublicize.
      # @return [Boolean] True of unpublicization successful, false otherwise.
      # @see https://developer.github.com/v3/orgs/members/#conceal-a-users-membership
      # @example
      #   @client.unpublicize_membership('github', 'pengwynn')
      # @example
      #   @client.conceal_membership('github', 'pengwynn')
      def unpublicize_membership(org, user, options = {})
        boolean_from_response :delete, "#{Organization.path org}/public_members/#{user}", options
      end
      alias :conceal_membership :unpublicize_membership

      # List all teams for the authenticated user across all their orgs
      #
      # @return [Array<Sawyer::Resource>] Array of team resources.
      # @see https://developer.github.com/v3/orgs/teams/#list-user-teams
      def user_teams(options = {})
        paginate "/user/teams", options
      end

      # Check if a user has a team membership.
      #
      # @param team_id [Integer] Team id.
      # @param user [String] GitHub username of the user to check.
      #
      # @return [Sawyer::Resource] Hash of team membership info
      #
      # @see https://developer.github.com/v3/orgs/teams/#get-team-membership
      #
      # @example Check if a user has a membership for a team
      #   @client.team_membership(1234, 'pengwynn')
      #   => false
      def team_membership(team_id, user, options = {})
        options = ensure_org_invitations_api_media_type(options)
        get "teams/#{team_id}/memberships/#{user}", options
      end

      # Invite a user to a team
      #
      # @param team_id [Integer] Team id.
      # @param user [String] GitHub username of the user to invite.
      #
      # @return [Sawyer::Resource] Hash of team membership info
      #
      # @see https://developer.github.com/v3/orgs/teams/#add-team-membership
      #
      # @example Check if a user has a membership for a team
      #   @client.add_team_membership(1234, 'pengwynn')
      #   => false
      def add_team_membership(team_id, user, options = {})
        options = ensure_org_invitations_api_media_type(options)
        put "teams/#{team_id}/memberships/#{user}", options
      end

      # Remove team membership
      #
      # @param team_id [Integer] Team id.
      # @param user [String] GitHub username of the user to boot.
      # @return [Boolean] True if user removed, false otherwise.
      # @see https://developer.github.com/v3/orgs/teams/#remove-team-membership
      # @example
      #   @client.remove_team_membership(100000, 'pengwynn')
      def remove_team_membership(team_id, user, options = {})
        options = ensure_org_invitations_api_media_type(options)
        boolean_from_response :delete, "teams/#{team_id}/memberships/#{user}", options
      end

      private

      def ensure_org_invitations_api_media_type(options = {})
        if options[:accept].nil?
          options[:accept] = ORG_INVITATIONS_PREVIEW_MEDIA_TYPE
          warn_org_invitations_preview
        end

        options
      end

      def warn_org_invitations_preview
        octokit_warn \
          "WARNING: The preview version of the Organization Team Memberships API " \
          "is not yet suitable for production use. You can avoid this message by " \
          "supplying an appropriate media type in the 'Accept' request header. " \
          "See the blog post for details: http://git.io/a9jglQ"
      end
    end
  end
end

# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Organizations API
    #
    # @see https://developer.github.com/v3/orgs/
    module Organizations
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
      alias org organization

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
      # @option values [String] :default_repository_permission The default permission members have on organization repositories.
      # @option values [Boolean] :members_can_create_repositories Set true to allow members to create repositories on the organization.
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
        patch Organization.path(org), options.merge(values)
      end
      alias update_org update_organization

      # Delete an organization.
      #
      # Requires authenticated organization owner.
      #
      # @param org [String, Integer] Organization login or ID.
      # @return [Boolean] True if deletion successful, otherwise false.
      # @see https://docs.github.com/rest/orgs/orgs#delete-an-organization
      # @example
      #   @client.delete_organization("my-org")
      # @example
      #   @client.delete_org("my-org")
      def delete_organization(org)
        boolean_from_response :delete, Organization.path(org)
      end
      alias delete_org delete_organization

      # Get organizations for a user.
      #
      # Nonauthenticated calls to this method will return organizations that
      # the user is a public member.
      #
      # Use an authenticated client to get both public and private organizations
      # for a user.
      #
      # Calling this method on a `@client` will return that users organizations.
      # Private organizations are included only if the `@client` is authenticated.
      #
      # @param user [Integer, String] GitHub user login or id of the user to get
      #   list of organizations.
      # @return [Array<Sawyer::Resource>] Array of hashes representing organizations.
      # @see https://developer.github.com/v3/orgs/#list-your-organizations
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
      def organizations(user = nil, options = {})
        paginate "#{User.path user}/orgs", options
      end
      alias list_organizations organizations
      alias list_orgs organizations
      alias orgs organizations

      # List all GitHub organizations
      #
      # This provides a list of every organization, in the order that they
      # were created.
      #
      # @param options [Hash] Optional options.
      # @option options [Integer] :since The integer ID of the last
      # Organization that you’ve seen.
      #
      # @see https://developer.github.com/v3/orgs/#list-all-organizations
      #
      # @return [Array<Sawyer::Resource>] List of GitHub organizations.
      def all_organizations(options = {})
        paginate 'organizations', options
      end
      alias all_orgs all_organizations

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
      alias org_repositories organization_repositories
      alias org_repos organization_repositories

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
        options = options.dup
        path = 'public_' if options.delete(:public)
        paginate "#{Organization.path org}/#{path}members", options
      end
      alias org_members organization_members

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
        organization_members org, options.merge(public: true)
      end
      alias org_public_members organization_public_members

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
      alias org_member? organization_member?

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
      alias org_public_member? organization_public_member?

      # List pending organization invitations
      #
      # Requires authenticated organization member.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @return [Array<Sawyer::Resource>] Array of hashes representing invitations.
      # @see https://developer.github.com/v3/orgs/members/#list-pending-organization-invitations
      #
      # @example
      #   @client.organization_invitations('github')
      def organization_invitations(org, options = {})
        get "#{Organization.path org}/invitations", options
      end
      alias org_invitations organization_invitations

      # List outside collaborators for an organization
      #
      # Requires authenticated organization members.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @return [Array<Sawyer::Resource>] Array of hashes representing users.
      # @see https://developer.github.com/v3/orgs/outside_collaborators/#list-outside-collaborators
      #
      # @example
      #   @client.outside_collaborators('github')
      def outside_collaborators(org, options = {})
        paginate "#{Organization.path org}/outside_collaborators", options
      end

      # Remove outside collaborator from an organization
      #
      # Requires authenticated organization members.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @param user [String] GitHub username to be removed as outside collaborator
      # @return [Boolean] Return true if outside collaborator removed from organization, false otherwise.
      # @see https://developer.github.com/v3/orgs/outside-collaborators/#remove-outside-collaborator
      #
      # @example
      #   @client.remove_outside_collaborator('github', 'lizzhale')
      def remove_outside_collaborator(org, user, options = {})
        boolean_from_response :delete, "#{Organization.path org}/outside_collaborators/#{user}", options
      end

      # Converts an organization member to an outside collaborator
      #
      # Requires authenticated organization members.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @param user [String] GitHub username to be removed as outside collaborator
      # @return [Boolean] Return true if outside collaborator removed from organization, false otherwise.
      # @see https://developer.github.com/v3/orgs/outside-collaborators/#convert-member-to-outside-collaborator
      #
      # @example
      #   @client.convert_to_outside_collaborator('github', 'lizzhale')
      def convert_to_outside_collaborator(org, user, options = {})
        boolean_from_response :put, "#{Organization.path org}/outside_collaborators/#{user}", options
      end

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
      alias org_teams organization_teams

      # Create team
      #
      # Requires authenticated organization owner.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @option options [String] :name Team name.
      # @option options [Array<String>] :repo_names Repositories for the team.
      # @option options [Array<String>] :maintainers Maintainers for the team.
      # @option options [Integer] :parent_team_id ID of a team to set as the parent team.
      # @return [Sawyer::Resource] Hash representing new team.
      # @see https://developer.github.com/v3/orgs/teams/#create-team
      # @example
      #   @client.create_team('github', {
      #     :name => 'Designers',
      #     :repo_names => ['github/dotfiles']
      #   })
      def create_team(org, options = {})
        if options.key?(:permission)
          octokit_warn 'Deprecated: Passing :permission option to #create_team. Assign team repository permission by passing :permission to #add_team_repository instead.'
        end
        post "#{Organization.path org}/teams", options
      end

      # Get team
      #
      # Requires authenticated organization member.
      #
      # @overload team(team_id, options = {})
      #   @param team_id [Integer] Team id.
      # @overload team(org, team, options = {})
      #   @param org [String, Integer] Organization GitHub login or id.
      #   @param team [String, Integer] Team slug or id.
      # @return [Sawyer::Resource] Hash representing team.
      # @see https://docs.github.com/en/rest/teams/teams#get-a-team-by-name
      # @example Get a team by id
      #   @client.team(100000)
      # @example Get a team by org id and team id
      #   @client.team(3430433, 100000)
      # @example Get a team by org name and team slug
      #   @client.team("github", "justice-league")
      def team(*args)
        path, options = team_path_and_options(args)
        get path, options
      end

      # Get team by name and org
      #
      # Requires authenticated organization member.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @param team_slug [String] Team slug.
      # @return [Sawyer::Resource] Hash representing team.
      # @see https://docs.github.com/en/rest/teams/teams#get-a-team-by-name
      # @example
      #   @client.team_by_name("github", "justice-league")
      def team_by_name(org, team_slug, options = {})
        get Team.path(org, team_slug), options
      end

      # Check team permissions for a repository
      #
      # Requires authenticated organization member.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @param team [String, Integer] Team slug or id.
      # @param owner [String] Owner name for the repository.
      # @param repo [String] Name of the repo to check permissions against.
      # @return [String, Sawyer::Resource] Depending on options it may be an empty string or a resource.
      # @example
      #   # Check whether the team has any permissions with the repository
      #   @client.team_permissions_for_repo("github", "justice-league", "octocat", "hello-world")
      #
      # @example
      #   # Get the full repository object including the permissions level and role for the team
      #   @client.team_permissions_for_repo("github", "justice-league", "octocat", "hello-world", :accept => 'application/vnd.github.v3.repository+json')
      # @see https://docs.github.com/en/rest/teams/teams#check-team-permissions-for-a-repository
      def team_permissions_for_repo(org, team, owner, repo, options = {})
        get "#{Team.path(org, team)}/repos/#{owner}/#{repo}", options
      end

      # List child teams
      #
      # Requires authenticated organization member.
      #
      # @overload child_teams(team_id, options = {})
      #   @param team_id [Integer] Team id.
      # @overload child_teams(org, team, options = {})
      #   @param org [String, Integer] Organization GitHub login or id.
      #   @param team [String, Integer] Team slug or id.
      # @return [Sawyer::Resource] Hash representing team.
      # @see https://docs.github.com/en/rest/teams/teams#list-child-teams
      # @example
      #   @client.child_teams(100000)
      # @example
      #   @client.child_teams("github", "justice-league")
      def child_teams(*args)
        path, options = team_path_and_options(args)
        paginate "#{path}/teams", options
      end

      # Update team
      #
      # Requires authenticated organization owner.
      #
      # @overload update_team(team_id, options = {})
      #   @param team_id [Integer] Team id.
      # @overload update_team(org, team, options = {})
      #   @param org [String, Integer] Organization GitHub login or id.
      #   @param team [String, Integer] Team slug or id.
      # @option options [String] :name Team name.
      # @option options [String] :permission Permissions the team has for team repositories.
      #
      #   `pull` - team members can pull, but not push to or administer these repositories.
      #   `push` - team members can pull and push, but not administer these repositories.
      #   `admin` - team members can pull, push and administer these repositories.
      # @option options [Integer] :parent_team_id ID of a team to set as the parent team.
      # @return [Sawyer::Resource] Hash representing updated team.
      # @see https://docs.github.com/en/rest/teams/teams#update-a-team
      # @example
      #   @client.update_team(100000, {
      #     :name => 'Front-end Designers',
      #     :permission => 'push'
      #   })
      # @example
      #   @client.update_team("github", "justice-league", {
      #     :name => 'Front-end Designers',
      #     :permission => 'push'
      #   })
      def update_team(*args)
        path, options = team_path_and_options(args)
        patch path, options
      end

      # Delete team
      #
      # Requires authenticated organization owner.
      #
      # @overload delete_team(team_id, options = {})
      #   @param team_id [Integer] Team id.
      # @overload delete_team(org, team, options = {})
      #   @param org [String, Integer] Organization GitHub login or id.
      #   @param team [String, Integer] Team slug or id.
      # @return [Boolean] True if deletion successful, false otherwise.
      # @see https://docs.github.com/en/rest/teams/teams#delete-a-team
      # @example
      #   @client.delete_team(100000)
      # @example
      #   @client.delete_team("github", "justice-league")
      def delete_team(*args)
        path, options = team_path_and_options(args)
        boolean_from_response :delete, path, options
      end

      # List team members
      #
      # Requires authenticated organization member. Team members include members
      # of child teams. Prefer the organization + team slug form, which maps to
      # <tt>GET /orgs/{org}/teams/{team_slug}/members</tt>.
      #
      # @overload team_members(team_id, options = {})
      #   @param team_id [Integer] Team id.
      # @overload team_members(org, team, options = {})
      #   @param org [String, Integer] Organization GitHub login or id.
      #   @param team [String, Integer] Team slug or id.
      # @option options [String] :role Filters members by role in the team.
      #   Can be one of: <tt>member</tt>, <tt>maintainer</tt>, or <tt>all</tt>
      #   (default).
      # @return [Array<Sawyer::Resource>] Array of hashes representing users.
      #   Each member may include <tt>role</tt> (<tt>member</tt> or
      #   <tt>maintainer</tt>) and <tt>inherited</tt> (whether membership comes
      #   from a child team).
      # @see https://docs.github.com/en/rest/teams/members#list-team-members
      # @example
      #   @client.team_members("github", "justice-league")
      # @example Filter to team maintainers
      #   @client.team_members("github", "justice-league", role: "maintainer")
      # @example Legacy team id form
      #   @client.team_members(100000)
      def team_members(*args)
        path, options = team_path_and_options(args)
        paginate "#{path}/members", options
      end

      # Add team member (Legacy)
      #
      # Requires authenticated organization owner or member with team
      # `admin` permission.
      #
      # @deprecated Use {#add_team_membership} with an organization and team slug
      #   instead. The legacy team member endpoints are closing down; see
      #   https://docs.github.com/en/rest/teams/members#add-or-update-team-membership-for-a-user
      #
      # @overload add_team_member(team_id, user, options = {})
      #   @param team_id [Integer] Team id.
      # @overload add_team_member(org, team, user, options = {})
      #   @param org [String, Integer] Organization GitHub login or id.
      #   @param team [String, Integer] Team slug or id.
      # @param user [String] GitHub username of new team member.
      # @return [Boolean] True on successful addition, false otherwise.
      # @see https://docs.github.com/en/rest/teams/members#add-team-member-legacy
      # @example
      #   @client.add_team_member(100000, 'pengwynn')
      # @example Preferred modern API
      #   @client.add_team_membership("github", "justice-league", "pengwynn")
      #
      # @example
      #   # Opt-in to future behavior for this endpoint. Adds the member to the
      #   # team if they're already an org member. If not, the method will return
      #   # 422 and indicate the user should call the new Team Membership endpoint.
      #   @client.add_team_member \
      #     100000,
      #     'pengwynn',
      #     :accept => "application/vnd.github.the-wasp-preview+json"
      # @see https://developer.github.com/changes/2014-08-05-team-memberships-api/
      def add_team_member(*args)
        octokit_warn 'Deprecated: #add_team_member uses a legacy Teams API path. Prefer #add_team_membership with an organization and team slug.'
        path, user, options = team_path_user_and_options(args)
        # There's a bug in this API call. The docs say to leave the body blank,
        # but it fails if the body is both blank and the content-length header
        # is not 0.
        boolean_from_response :put, "#{path}/members/#{user}", options.merge({ name: user })
      end

      # Remove team member (Legacy)
      #
      # Requires authenticated organization owner or member with team
      # `admin` permission.
      #
      # @deprecated Use {#remove_team_membership} with an organization and team slug
      #   instead. The legacy team member endpoints are closing down.
      #
      # @overload remove_team_member(team_id, user, options = {})
      #   @param team_id [Integer] Team id.
      # @overload remove_team_member(org, team, user, options = {})
      #   @param org [String, Integer] Organization GitHub login or id.
      #   @param team [String, Integer] Team slug or id.
      # @param user [String] GitHub username of the user to boot.
      # @return [Boolean] True if user removed, false otherwise.
      # @see https://docs.github.com/en/rest/teams/members#remove-team-member-legacy
      # @example
      #   @client.remove_team_member(100000, 'pengwynn')
      # @example Preferred modern API
      #   @client.remove_team_membership("github", "justice-league", "pengwynn")
      def remove_team_member(*args)
        octokit_warn 'Deprecated: #remove_team_member uses a legacy Teams API path. Prefer #remove_team_membership with an organization and team slug.'
        path, user, options = team_path_user_and_options(args)
        boolean_from_response :delete, "#{path}/members/#{user}", options
      end

      # Check if a user is a member of a team (Legacy)
      #
      # Use this to check if another user is a member of a team that
      # you are a member.
      #
      # @deprecated Use {#team_membership} with an organization and team slug
      #   instead. The legacy get team member endpoint is closing down.
      #
      # @overload team_member?(team_id, user, options = {})
      #   @param team_id [Integer] Team id.
      # @overload team_member?(org, team, user, options = {})
      #   @param org [String, Integer] Organization GitHub login or id.
      #   @param team [String, Integer] Team slug or id.
      # @param user [String] GitHub username of the user to check.
      #
      # @return [Boolean] Is a member?
      #
      # @see https://docs.github.com/en/rest/teams/members#get-team-member-legacy
      #
      # @example Check if a user is in your team
      #   @client.team_member?(100000, 'pengwynn')
      #   => false
      # @example Preferred modern API
      #   @client.team_membership("github", "justice-league", "pengwynn")
      def team_member?(*args)
        octokit_warn 'Deprecated: #team_member? uses a legacy Teams API path. Prefer #team_membership with an organization and team slug.'
        path, user, options = team_path_user_and_options(args)
        boolean_from_response :get, "#{path}/members/#{user}", options
      end

      # List pending team invitations
      #
      # Requires authenticated organization member.
      #
      # @overload team_invitations(team_id, options = {})
      #   @param team_id [Integer] Team id.
      # @overload team_invitations(org, team, options = {})
      #   @param org [String, Integer] Organization GitHub login or id.
      #   @param team [String, Integer] Team slug or id.
      # @return [Array<Sawyer::Resource>] Array of hashes representing invitations.
      # @see https://docs.github.com/en/rest/teams/members#list-pending-team-invitations
      #
      # @example
      #   @client.team_invitations(100000)
      # @example
      #   @client.team_invitations("github", "justice-league")
      def team_invitations(*args)
        path, options = team_path_and_options(args)
        get "#{path}/invitations", options
      end

      # List team repositories
      #
      # Requires authenticated organization member.
      #
      # @overload team_repositories(team_id, options = {})
      #   @param team_id [Integer] Team id.
      # @overload team_repositories(org, team, options = {})
      #   @param org [String, Integer] Organization GitHub login or id.
      #   @param team [String, Integer] Team slug or id.
      # @return [Array<Sawyer::Resource>] Array of hashes representing repositories.
      # @see https://docs.github.com/en/rest/teams/teams#list-team-repositories
      # @example
      #   @client.team_repositories(100000)
      # @example
      #   @client.team_repos("github", "justice-league")
      def team_repositories(*args)
        path, options = team_path_and_options(args)
        paginate "#{path}/repos", options
      end
      alias team_repos team_repositories

      # Check if a repo is managed by a specific team
      #
      # @overload team_repository?(team_id, repo, options = {})
      #   @param team_id [Integer] Team ID.
      # @overload team_repository?(org, team, repo, options = {})
      #   @param org [String, Integer] Organization GitHub login or id.
      #   @param team [String, Integer] Team slug or id.
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Boolean] True if managed by a team. False if not managed by
      #   the team OR the requesting user does not have authorization to access
      #   the team information.
      # @see https://docs.github.com/en/rest/teams/teams#check-team-permissions-for-a-repository
      # @example
      #   @client.team_repository?(8675309, 'octokit/octokit.rb')
      # @example
      #   @client.team_repo?("github", "justice-league", "octokit/octokit.rb")
      def team_repository?(*args)
        path, repo, _options = team_path_repo_and_options(args)
        boolean_from_response :get, "#{path}/repos/#{Repository.new(repo)}"
      end
      alias team_repo? team_repository?

      # Add or update team repository permissions
      #
      # To add a repository to a team or update the team's permission on a
      # repository. The authenticated user must have admin access to the
      # repository and must be able to see the team. The repository must be owned
      # by the organization, or a direct fork of a repository owned by the
      # organization.
      #
      # @overload add_team_repository(team_id, repo, options = {})
      #   @param team_id [Integer] Team id.
      # @overload add_team_repository(org, team, repo, options = {})
      #   @param org [String, Integer] Organization GitHub login or id.
      #   @param team [String, Integer] Team slug or id.
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @option options [String] :permission The permission to grant the team on
      #   this repository. Accepted values are <tt>pull</tt>, <tt>triage</tt>,
      #   <tt>push</tt>, <tt>maintain</tt>, <tt>admin</tt>, or a custom
      #   repository role name defined by the organization. If not specified, the
      #   team's <tt>permission</tt> attribute will be used.
      # @return [Boolean] True if successful, false otherwise.
      # @see Octokit::Repository
      # @see https://docs.github.com/en/rest/teams/teams#add-or-update-team-repository-permissions
      # @example
      #   @client.add_team_repository(100000, 'github/developer.github.com')
      # @example
      #   @client.add_team_repo("github", "justice-league", "github/developer.github.com")
      # @example Add a team with write (push) permissions
      #   @client.add_team_repository("github", "justice-league", "github/developer.github.com", permission: "push")
      # @example Add a team with admin permissions
      #   @client.add_team_repository("github", "justice-league", "github/developer.github.com", permission: "admin")
      def add_team_repository(*args)
        path, repo, options = team_path_repo_and_options(args)
        boolean_from_response :put, "#{path}/repos/#{Repository.new(repo)}", options
      end
      alias add_team_repo add_team_repository

      # Remove team repository
      #
      # Removes repository from team. Does not delete the repository.
      #
      # Requires authenticated organization owner.
      #
      # @overload remove_team_repository(team_id, repo, options = {})
      #   @param team_id [Integer] Team id.
      # @overload remove_team_repository(org, team, repo, options = {})
      #   @param org [String, Integer] Organization GitHub login or id.
      #   @param team [String, Integer] Team slug or id.
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @return [Boolean] Return true if repo removed from team, false otherwise.
      # @see Octokit::Repository
      # @see https://docs.github.com/en/rest/teams/teams#remove-a-repository-from-a-team
      # @example
      #   @client.remove_team_repository(100000, 'github/developer.github.com')
      # @example
      #   @client.remove_team_repo("github", "justice-league", "github/developer.github.com")
      def remove_team_repository(*args)
        path, repo, _options = team_path_repo_and_options(args)
        boolean_from_response :delete, "#{path}/repos/#{Repository.new(repo)}"
      end
      alias remove_team_repo remove_team_repository

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
      alias remove_org_member remove_organization_member

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
      alias conceal_membership unpublicize_membership

      # List all teams for the authenticated user across all their orgs
      #
      # @return [Array<Sawyer::Resource>] Array of team resources.
      # @see https://developer.github.com/v3/orgs/teams/#list-user-teams
      def user_teams(options = {})
        paginate 'user/teams', options
      end

      # Check if a user has a team membership.
      #
      # @overload team_membership(team_id, user, options = {})
      #   @param team_id [Integer] Team id.
      # @overload team_membership(org, team, user, options = {})
      #   @param org [String, Integer] Organization GitHub login or id.
      #   @param team [String, Integer] Team slug or id.
      # @param user [String] GitHub username of the user to check.
      #
      # @return [Sawyer::Resource] Hash of team membership info
      #
      # @see https://docs.github.com/en/rest/teams/members#get-team-membership-for-a-user
      #
      # @example Check if a user has a membership for a team
      #   @client.team_membership(1234, 'pengwynn')
      # @example
      #   @client.team_membership("github", "justice-league", "pengwynn")
      def team_membership(*args)
        path, user, options = team_path_user_and_options(args)
        get "#{path}/memberships/#{user}", options
      end

      # Add or invite a user to a team
      #
      # Prefer the organization + team slug form, which maps to
      # <tt>PUT /orgs/{org}/teams/{team_slug}/memberships/{username}</tt>.
      #
      # @overload add_team_membership(team_id, user, options = {})
      #   @param team_id [Integer] Team id.
      # @overload add_team_membership(org, team, user, options = {})
      #   @param org [String, Integer] Organization GitHub login or id.
      #   @param team [String, Integer] Team slug or id.
      # @param user [String] GitHub username of the user to invite.
      # @option options [String] :role The role that this user should have in the
      #   team. Can be one of: <tt>member</tt> or <tt>maintainer</tt>.
      #   Default: <tt>member</tt>.
      #
      # @return [Sawyer::Resource] Hash of team membership info
      #
      # @see https://docs.github.com/en/rest/teams/members#add-or-update-team-membership-for-a-user
      #
      # @example
      #   @client.add_team_membership("github", "justice-league", "pengwynn")
      # @example Assign the maintainer role
      #   @client.add_team_membership("github", "justice-league", "pengwynn", role: "maintainer")
      def add_team_membership(*args)
        path, user, options = team_path_user_and_options(args)
        put "#{path}/memberships/#{user}", options
      end

      # Remove team membership
      #
      # @overload remove_team_membership(team_id, user, options = {})
      #   @param team_id [Integer] Team id.
      # @overload remove_team_membership(org, team, user, options = {})
      #   @param org [String, Integer] Organization GitHub login or id.
      #   @param team [String, Integer] Team slug or id.
      # @param user [String] GitHub username of the user to boot.
      # @return [Boolean] True if user removed, false otherwise.
      # @see https://docs.github.com/en/rest/teams/members#remove-team-membership-for-a-user
      # @example
      #   @client.remove_team_membership(100000, 'pengwynn')
      # @example
      #   @client.remove_team_membership("github", "justice-league", "pengwynn")
      def remove_team_membership(*args)
        path, user, options = team_path_user_and_options(args)
        boolean_from_response :delete, "#{path}/memberships/#{user}", options
      end

      # List all organizations memberships for the authenticated user
      #
      # @return [Array<Sawyer::Resource>] Array of organizations memberships.
      # @see https://developer.github.com/v3/orgs/members/#list-your-organization-memberships
      def organization_memberships(options = {})
        paginate 'user/memberships/orgs', options
      end
      alias org_memberships organization_memberships

      # Get an organization membership
      #
      # @param org [Integer, String] The GitHub Organization.
      # @option options [String] :user  The login of the user, otherwise authenticated user.
      # @return [Sawyer::Resource] Hash representing the organization membership.
      # @see https://developer.github.com/v3/orgs/members/#get-your-organization-membership
      # @see https://developer.github.com/v3/orgs/members/#get-organization-membership
      def organization_membership(org, options = {})
        options = options.dup
        if user = options.delete(:user)
          get "#{Organization.path(org)}/memberships/#{user}", options
        else
          get "user/memberships/orgs/#{org}", options
        end
      end
      alias org_membership organization_membership

      # Edit an organization membership
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @option options [String] :role  The role of the user in the organization.
      # @option options [String] :state The state that the membership should be in.
      # @option options [String] :user  The login of the user, otherwise authenticated user.
      # @return [Sawyer::Resource] Hash representing the updated organization membership.
      # @see https://developer.github.com/v3/orgs/members/#edit-your-organization-membership
      # @see https://developer.github.com/v3/orgs/members/#add-or-update-organization-membership
      def update_organization_membership(org, options = {})
        options = options.dup
        if user = options.delete(:user)
          options.delete(:state)
          put "#{Organization.path(org)}/memberships/#{user}", options
        else
          options.delete(:role)
          patch "user/memberships/orgs/#{org}", options
        end
      end
      alias update_org_membership update_organization_membership

      # Remove an organization membership
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @return [Boolean] Success
      # @see https://developer.github.com/v3/orgs/members/#remove-organization-membership
      def remove_organization_membership(org, options = {})
        options = options.dup
        user = options.delete(:user)
        user && boolean_from_response(:delete, "#{Organization.path(org)}/memberships/#{user}", options)
      end
      alias remove_org_membership remove_organization_membership

      # Initiates the generation of a migration archive.
      #
      # Requires authenticated organization owner.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @param repositories [Array<String>] :repositories Repositories for the organization.
      # @option options [Boolean, optional] :lock_repositories Indicates whether repositories should be locked during migration
      # @return [Sawyer::Resource] Hash representing the new migration.
      # @example
      #   @client.start_migration('github', ['github/dotfiles'])
      # @see https://docs.github.com/en/rest/reference/migrations#start-an-organization-migration
      def start_migration(org, repositories, options = {})
        options[:repositories] = repositories
        post "#{Organization.path(org)}/migrations", options
      end

      # Lists the most recent migrations.
      #
      # Requires authenticated organization owner.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @return [Array<Sawyer::Resource>] Array of migration resources.
      # @see https://docs.github.com/en/rest/reference/migrations#list-organization-migrations
      def migrations(org, options = {})
        paginate "#{Organization.path(org)}/migrations", options
      end

      # Fetches the status of a migration.
      #
      # Requires authenticated organization owner.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @param id [Integer] ID number of the migration.
      # @see https://docs.github.com/en/rest/reference/migrations#get-an-organization-migration-status
      def migration_status(org, id, options = {})
        get "#{Organization.path(org)}/migrations/#{id}", options
      end

      # Fetches the URL to a migration archive.
      #
      # Requires authenticated organization owner.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @param id [Integer] ID number of the migration.
      # @see https://docs.github.com/en/rest/reference/migrations#download-an-organization-migration-archive
      def migration_archive_url(org, id, options = {})
        url = "#{Organization.path(org)}/migrations/#{id}/archive"

        response = client_without_redirects(options).get(url)
        response.headers['location']
      end

      # Deletes a previous migration archive.
      #
      # Requires authenticated organization owner.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @param id [Integer] ID number of the migration.
      # @see https://docs.github.com/en/rest/reference/migrations#delete-an-organization-migration-archive
      def delete_migration_archive(org, id, options = {})
        delete "#{Organization.path(org)}/migrations/#{id}/archive", options
      end

      # Unlock a previous migration archive.
      #
      # Requires authenticated organization owner.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @param id [Integer] ID number of the migration.
      # @param repo [String] Name of the repository.
      # @see https://docs.github.com/en/rest/reference/migrations#unlock-an-organization-repository
      def unlock_repository(org, id, repo, options = {})
        delete "#{Organization.path(org)}/migrations/#{id}/repos/#{repo}/lock", options
      end

      # Get GitHub Actions billing for an organization
      #
      # Requires authenticated organization owner.
      #
      # @param org [String, Integer] Organization GitHub login or id.
      # @return [Sawyer::Resource] Hash representing GitHub Actions billing for an organization.
      # @see https://docs.github.com/en/rest/reference/billing#get-github-actions-billing-for-an-organization
      #
      # @example
      #   @client.billing_actions('github')
      def billing_actions(org)
        get "#{Organization.path(org)}/settings/billing/actions"
      end

      # Get organization audit log.
      #
      # Gets the audit log for an organization.
      #
      # @param org [String, Integer] Organization GitHub login or id for which
      #   to retrieve the audit log.
      # @option options [String] :include ('all') Filter by event type.
      #   `all`, `git` or `web`.
      # @option options [String] :phrase A search phrase.
      # @option options [String] :order ('desc') The order of audit log events. To list newest events first, specify desc.
      # To list oldest events first, specify asc.
      #
      # @return [Array<Sawyer::Resource>] List of events
      # @see https://docs.github.com/en/enterprise-cloud@latest/rest/orgs/orgs#get-the-audit-log-for-an-organization
      # @example
      #   Octokit.organization_audit_log('github', {include: 'all', phrase: 'action:org.add_member created:>2022-08-29 user:octocat'})
      def organization_audit_log(org, options = {})
        paginate "#{Organization.path org}/audit-log", options
      end

      private

      # Build a team API path from either a team id or org + team identifiers.
      #
      # @param args [Array] Method arguments, optionally ending with an options Hash.
      # @return [Array(String, Hash)] path and options
      def team_path_and_options(args)
        args = args.dup
        options = args.last.is_a?(Hash) ? args.pop : {}
        case args.length
        when 1
          ["teams/#{args[0]}", options]
        when 2
          [Team.path(args[0], args[1]), options]
        else
          raise ArgumentError, "wrong number of arguments (given #{args.length}, expected 1 or 2)"
        end
      end

      # Build a team API path when the final positional argument is a username.
      #
      # @param args [Array] Method arguments, optionally ending with an options Hash.
      # @return [Array(String, String, Hash)] path, user, and options
      def team_path_user_and_options(args)
        args = args.dup
        options = args.last.is_a?(Hash) ? args.pop : {}
        user = args.pop
        path, _ = team_path_and_options(args + [options])
        [path, user, options]
      end

      # Build a team API path when the final positional argument is a repository.
      #
      # @param args [Array] Method arguments, optionally ending with an options Hash.
      # @return [Array(String, Object, Hash)] path, repo, and options
      def team_path_repo_and_options(args)
        args = args.dup
        options = args.last.is_a?(Hash) ? args.pop : {}
        repo = args.pop
        path, _ = team_path_and_options(args + [options])
        [path, repo, options]
      end
    end
  end
end

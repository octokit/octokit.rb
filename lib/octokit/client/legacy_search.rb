module Octokit
  class Client
    module LegacySearch

      # Legacy repository search
      #
      # @see http://developer.github.com/v3/search/#search-repositories
      # @param q [String] Search keyword
      # @return [Array<Hashie::Mash>] List of repositories found
      def legacy_search_repositories(q, options={})
        get("legacy/repos/search/#{q}", options)['repositories']
      end

      def search_repositories(q, options = {})
        warn "DEPRECATED: search_repositories is deprecated, please use legacy_search_repositories"
        legacy_search_repositories(q, options)
      end
      alias :search_repos :search_repositories

      # Legacy search issues within a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param search_term [String] The term to search for
      # @param state [String] :state (open) <tt>open</tt> or <tt>closed</tt>.
      # @return [Array] A list of issues matching the search term and state
      # @example Search for 'test' in the open issues for sferik/rails_admin
      #   Octokit.search_issues("sferik/rails_admin", 'test', 'open')
      def legacy_search_issues(repo, search_term, state='open', options={})
        get("legacy/issues/search/#{Repository.new(repo)}/#{state}/#{search_term}", options)['issues']
      end

      def search_issues(repo, search_term, state = 'open', options = {})
        warn "DEPRECATED: search_issues is deprecated, please use legacy_search_issues"
        legacy_search_issues(repo, search_term, state, options)
      end

      # Search for user.
      #
      # @param search [String] User to search for.
      # @return [Array<Hashie::Mash>] Array of hashes representing users.
      # @see http://developer.github.com/v3/search/#search-users
      # @example
      #   Octokit.search_users('pengwynn')
      def legacy_search_users(search, options={})
        get("legacy/user/search/#{search}", options)['users']
      end

      def search_users(search, options = {})
        warn "DEPRECATED: search_users is deprecated, please use legacy_search_users"
        legacy_search_users(search, options = {})
      end
    end
  end
end

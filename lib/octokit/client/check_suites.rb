module Octokit
  class Client

    # Methods for the Check Suites API
    #
    # @see https://developer.github.com/v3/checks/suites
    module CheckSuites

      # Get a single check suite
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param id [Integer] The check suite id
      # @return [Sawyer::Resource] The check suite
      # @see https://developer.github.com/v3/checks/suites/#get-a-single-check-suite
      # @example
      #   Octokit.check_suite('rails/rails', 1)
      def check_suite(repo, id, options = {})
        opts = ensure_api_media_type(:checks, options)
        get "#{Repository.path repo}/check-suites/#{id}", opts
      end

      # List check suites for a specific ref
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param ref [String] A SHA, branch name, or a tag name
      # @param options [Hash] Method options
      # @option options [String] :app_id Filters check suites by GitHub App id.
      # @option options [String] :check_name Filters checks suites by the name of the check run.
      # @return [Array<Sawyer::Resource>] Array of check suites
      # @see https://developer.github.com/v3/checks/suites/#list-check-suites-for-a-specific-ref
      # @example
      #   Octokit.check_suites('rails/rails', app_id: 1)
      def check_suites(repo, ref, options = {})
        opts = ensure_api_media_type(:checks, options)
        paginate "#{Repository.path repo}/commits/#{ref}/check-suites", opts
      end

      # Set preferences for check suites on a repository
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param options [Hash] Method options
      # @option options [Array<Hash>] :auto_trigger_checks Enables or disables automatic creation of CheckSuite events upon pushes to the repository
      # @option auto_trigger_checks [Integer] :app_id Required. The id of the GitHub App.
      # @option auto_trigger_checks [Boolean] :setting Required. Set to true to enable automatic creation of CheckSuite events upon pushes to the repository, or false to disable them. Default: true
      # @return [Sawyer::Resource] The preferences
      # @see https://developer.github.com/v3/checks/suites/#set-preferences-for-check-suites-on-a-repository
      # @example
      #   Octokit.set_check_suite_preferences('rails/rails', { auto_trigger_checks: [{ app_id: 1, setting: true }]})
      def set_check_suites_preferences(repo, options = {})
        opts = ensure_api_media_type(:checks, options)
        patch "#{Repository.path repo}/check-suites/preferences", opts
      end

      # Create a check suite
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param head_sha [String] The sha of the head commit.
      # @return [Sawyer::Resource] The new check suite
      # @see https://developer.github.com/v3/checks/suites/#create-a-check-suite
      # @example
      #   check_suite = Octokit.create_check_suite('rails/rails', '827efc6d56897b048c772eb4087f854f46256132')
      #   check_suite.head_sha # => "827efc6d56897b048c772eb4087f854f46256132"
      #   check_suite.conclusion # => "neutral"
      def create_check_suite(repo, head_sha, options = {})
        params = { name: name, head_sha: head_sha }
        opts = ensure_api_media_type(:checks, options)
        post "#{Repository.path repo}/check-suites", opts.merge(params)
      end

      # Rerequest check suite
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param id [Integer] The check suite id
      # @see https://developer.github.com/v3/checks/suites/#rerequest-check-suite
      # @example
      #   Octokit.rerequest_check_suite('rails/rails', 1)
      def rerequest_check_suite(repo, id, options = {})
        opts = ensure_api_media_type(:checks, options)
        post "#{Repository.path repo}/check-suites/#{id}/rerequest", opts
      end
    end
  end
end

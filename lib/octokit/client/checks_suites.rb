# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the ChecksSuites API
    #
    # @see https://developer.github.com/v3/checks/suites/
    module ChecksSuites
      # Get a check suite
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param check_suite_id [Integer] The ID of the check suite
      # @return [Sawyer::Resource] A single suite
      # @see https://developer.github.com/v3/checks/suites/#get-a-check-suite
      def check_suite(repo, check_suite_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.antiope-preview+json' if opts[:accept].nil?

        get "#{Repository.path repo}/check-suites/#{check_suite_id}", opts
      end

      # Create a check suite
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param head_sha [String] The sha of the head commit.
      # @return [Sawyer::Resource] The new suite
      # @see https://developer.github.com/v3/checks/suites/#create-a-check-suite
      def create_check_suite(repo, head_sha, options = {})
        opts = options.dup
        opts[:head_sha] = head_sha
        opts[:accept] = 'application/vnd.github.antiope-preview+json' if opts[:accept].nil?

        post "#{Repository.path repo}/check-suites", opts
      end

      # Rerequest a check suite
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param check_suite_id [Integer] The ID of the check suite
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/checks/suites/#rerequest-a-check-suite
      def rerequest_check_suite(repo, check_suite_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.antiope-preview+json' if opts[:accept].nil?

        boolean_from_response :post, "#{Repository.path repo}/check-suites/#{check_suite_id}/rerequest", opts
      end

      # Update repository preferences for check suites
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [Array] :auto_trigger_checks Enables or disables automatic creation of CheckSuite events upon pushes to the repository. Enabled by default. See the auto_trigger_checks object (https://developer.github.com/v3/checks/suites/#auto_trigger_checks-object) description for details.
      # @return [Sawyer::Resource] The updated preferences
      # @see https://developer.github.com/v3/checks/suites/#update-repository-preferences-for-check-suites
      def set_suites_preferences(repo, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.antiope-preview+json' if opts[:accept].nil?

        patch "#{Repository.path repo}/check-suites/preferences", opts
      end

      # List check suites for a Git reference
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param ref [String] The ref of the suites
      # @option options [Integer] :app_id The ID of the app
      # @option options [String] :check_name Filters checks suites by the name of the check run (https://developer.github.com/v3/checks/runs/).
      # @return [Array<Sawyer::Resource>] A list of suites
      # @see https://developer.github.com/v3/checks/suites/#list-check-suites-for-a-git-reference
      def ref_suites(repo, ref, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.antiope-preview+json' if opts[:accept].nil?

        paginate "#{Repository.path repo}/commits/#{ref}/check-suites", opts
      end
    end
  end
end

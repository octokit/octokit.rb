module Octokit
  class Client

    # Methods for the Checks API
    #
    # @see https://developer.github.com/v3/checks/
    module Checks

      # Methods for Check Runs
      #
      # @see https://developer.github.com/v3/checks/runs/

      # Create a check run
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param name [String] The name of the check
      # @param head_sha [String] The SHA of the commit to check
      # @return [Sawyer::Resource] A hash representing the new check run
      # @see https://developer.github.com/v3/checks/runs/#create-a-check-run
      # @example Create a check run
      #   check_run = Octokit.create_check_run("octocat/Hello-World", "my-check", "7638417db6d59f3c431d3e1f261cc637155684cd")
      #   check_run.name # => "my-check"
      #   check_run.head_sha # => "7638417db6d59f3c431d3e1f261cc637155684cd"
      #   check_run.status # => "queued"
      def create_check_run(repo, name, head_sha, options = {})
        opts = ensure_api_media_type(:checks, options)
        opts[:name] = name
        opts[:head_sha] = head_sha

        post "#{Repository.path repo}/check-runs", opts
      end

      # Update a check run
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param id [Integer] The ID of the check run
      # @return [Sawyer::Resource] A hash representing the updated check run
      # @see https://developer.github.com/v3/checks/runs/#update-a-check-run
      # @example Update a check run
      #   check_run = Octokit.update_check_run("octocat/Hello-World", 51295429, status: "in_progress")
      #   check_run.id # => 51295429
      #   check_run.status # => "in_progress"
      def update_check_run(repo, id, options = {})
        opts = ensure_api_media_type(:checks, options)

        patch "#{Repository.path repo}/check-runs/#{id}", opts
      end

      def check_runs_for_ref(repo, ref, options = {})
        opts = ensure_api_media_type(:checks, options)

        get "#{Repository.path repo}/commits/#{ref}/check-runs", opts
      end
      alias :list_check_runs_for_ref :check_runs_for_ref

      def check_runs_for_check_suite(repo, id, options = {})
        opts = ensure_api_media_type(:checks, options)

        get "#{Repository.path repo}/check-suites/#{id}/check-runs", opts
      end
      alias :list_check_runs_for_check_suite :check_runs_for_check_suite

      def check_run(repo, id, options = {})
        opts = ensure_api_media_type(:checks, options)

        get "#{Repository.path repo}/check-runs/#{id}", opts
      end

      def check_run_annotations(repo, id, options = {})
        opts = ensure_api_media_type(:checks, options)

        get "#{Repository.path repo}/check-runs/#{id}/annotations", opts
      end

      # Methods for Check Suites
      #
      # @see https://developer.github.com/v3/checks/suites/

      def check_suite(repo, id, options = {})
        opts = ensure_api_media_type(:checks, options)

        get "#{Repository.path repo}/check-suites/#{id}", opts
      end

      def check_suites_for_ref(repo, ref, options = {})
        opts = ensure_api_media_type(:checks, options)

        get "#{Repository.path repo}/commits/#{ref}/check-suites", opts
      end
      alias :list_check_suites_for_ref :check_suites_for_ref

      def set_check_suite_preferences(repo, options = {})
        opts = ensure_api_media_type(:checks, options)

        patch "#{Repository.path repo}/check-suites/preferences", opts
      end

      def create_check_suite(repo, head_sha, options = {})
        opts = ensure_api_media_type(:checks, options)
        opts[:head_sha] = head_sha

        post "#{Repository.path repo}/check-suites", opts
      end

      def rerequest_check_suite(repo, id, options = {})
        opts = ensure_api_media_type(:checks, options)

        post "#{Repository.path repo}/check-suites/#{id}/rerequest", opts
      end
    end
  end
end

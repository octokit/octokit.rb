module Octokit
  class Client

    # Methods for the Checks API
    #
    # @see https://developer.github.com/v3/checks/
    module Checks

      # Methods for Check Runs
      #
      # @see https://developer.github.com/v3/checks/runs/

      def create_check_run(repo, name, head_sha, options = {})
        opts = ensure_api_media_type(:checks, options)
        opts[:name] = name
        opts[:head_sha] = head_sha

        post "#{Repository.path repo}/check-runs", opts
      end

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
      alias :annotations_for_check_run :check_run_annotations
      alias :list_annotations_for_check_run :check_run_annotations

      # Methods for Check Suites
      #
      # @see https://developer.github.com/v3/checks/suites/

      def check_suite
        # TODO
      end

      def check_suites_for_ref
        # TODO
      end
      alias :list_check_suites_for_ref :check_suites_for_ref

      def set_check_suite_preferences
        # TODO
      end

      def create_check_suite
        # TODO
      end

      def rerequest_check_suite
        # TODO
      end
    end
  end
end

# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the ChecksRuns API
    #
    # @see https://developer.github.com/v3/checks/runs/
    module ChecksRuns
      # Get a check run
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param check_run_id [Integer] The ID of the check run
      # @return [Sawyer::Resource] A single check
      # @see https://developer.github.com/v3/checks/runs/#get-a-check-run
      def check(repo, check_run_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.antiope-preview+json' if opts[:accept].nil?

        get "#{Repository.path repo}/check-runs/#{check_run_id}", opts
      end

      # Create a check run
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param name [String] The name of the check. For example, "code-coverage".
      # @param head_sha [String] The SHA of the commit.
      # @option options [String] :details_url The URL of the integrator's site that has the full details of the check. If the integrator does not provide this, then the homepage of the GitHub app is used.
      # @option options [String] :external_id The ID of the external
      # @option options [String] :status The current status. Can be one of queued, in_progress, or completed.
      # @option options [String] :started_at The time that the check run began. This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ.
      # @option options [String] :conclusion Required if you provide completed_at or a status of completed. The final conclusion of the check. Can be one of success, failure, neutral, cancelled, skipped, timed_out, or action_required. When the conclusion is action_required, additional details should be provided on the site specified by details_url.  Note: Providing conclusion will automatically set the status parameter to completed. Only GitHub can change a check run conclusion to stale.
      # @option options [String] :completed_at The time the check completed. This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ.
      # @option options [Object] :output Check runs can accept a variety of data in the output object, including a title and summary and can optionally provide descriptive details about the run. See the output object (https://developer.github.com/v3/checks/runs/#output-object) description.
      # @option options [Array] :actions Displays a button on GitHub that can be clicked to alert your app to do additional tasks. For example, a code linting app can display a button that automatically fixes detected errors. The button created in this object is displayed after the check run completes. When a user clicks the button, GitHub sends the check_run.requested_action webhook (https://developer.github.com/webhooks/event-payloads/#check_run) to your app. Each action includes a label, identifier and description. A maximum of three actions are accepted. See the actions object (https://developer.github.com/v3/checks/runs/#actions-object) description. To learn more about check runs and requested actions, see "Check runs and requested actions (https://developer.github.com/v3/checks/runs/#check-runs-and-requested-actions)." To learn more about check runs and requested actions, see "Check runs and requested actions (https://developer.github.com/v3/checks/runs/#check-runs-and-requested-actions)."
      # @return [Sawyer::Resource] The new check
      # @see https://developer.github.com/v3/checks/runs/#create-a-check-run
      def create_check(repo, name, head_sha, options = {})
        opts = options.dup
        opts[:name] = name
        opts[:head_sha] = head_sha
        opts[:accept] = 'application/vnd.github.antiope-preview+json' if opts[:accept].nil?

        post "#{Repository.path repo}/check-runs", opts
      end

      # Update a check run
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param check_run_id [Integer] The ID of the check run
      # @option options [String] :name The name of the check. For example, "code-coverage".
      # @option options [String] :details_url The URL of the integrator's site that has the full details of the check.
      # @option options [String] :external_id The ID of the external
      # @option options [String] :started_at This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ.
      # @option options [String] :status The current status. Can be one of queued, in_progress, or completed.
      # @option options [String] :conclusion Required if you provide completed_at or a status of completed. The final conclusion of the check. Can be one of success, failure, neutral, cancelled, skipped, timed_out, or action_required.  Note: Providing conclusion will automatically set the status parameter to completed. Only GitHub can change a check run conclusion to stale.
      # @option options [String] :completed_at The time the check completed. This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ.
      # @option options [Object] :output Check runs can accept a variety of data in the output object, including a title and summary and can optionally provide descriptive details about the run. See the output object (https://developer.github.com/v3/checks/runs/#output-object-1) description.
      # @option options [Array] :actions Possible further actions the integrator can perform, which a user may trigger. Each action includes a label, identifier and description. A maximum of three actions are accepted. See the actions object (https://developer.github.com/v3/checks/runs/#actions-object) description. To learn more about check runs and requested actions, see "Check runs and requested actions (https://developer.github.com/v3/checks/runs/#check-runs-and-requested-actions)."
      # @return [Sawyer::Resource] The updated check
      # @see https://developer.github.com/v3/checks/runs/#update-a-check-run
      def update_check(repo, check_run_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.antiope-preview+json' if opts[:accept].nil?

        patch "#{Repository.path repo}/check-runs/#{check_run_id}", opts
      end

      # List check run annotations
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param check_run_id [Integer] The ID of the check run
      # @return [Array<Sawyer::Resource>] A list of annotations
      # @see https://developer.github.com/v3/checks/runs/#list-check-run-annotations
      def check_annotations(repo, check_run_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.antiope-preview+json' if opts[:accept].nil?

        paginate "#{Repository.path repo}/check-runs/#{check_run_id}/annotations", opts
      end

      # List check runs in a check suite
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param check_suite_id [Integer] The ID of the check suite
      # @option options [String] :check_name Returns check runs with the specified name.
      # @option options [String] :status Returns check runs with the specified status. Can be one of queued, in_progress, or completed.
      # @option options [String] :filter Filters check runs by their completed_at timestamp. Can be one of latest (returning the most recent check runs) or all.
      # @return [Array<Sawyer::Resource>] A list of checks
      # @see https://developer.github.com/v3/checks/runs/#list-check-runs-in-a-check-suite
      def suite_checks(repo, check_suite_id, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.antiope-preview+json' if opts[:accept].nil?

        paginate "#{Repository.path repo}/check-suites/#{check_suite_id}/check-runs", opts
      end

      # List check runs for a Git reference
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param ref [String] The ref of the checks
      # @option options [String] :check_name Returns check runs with the specified name.
      # @option options [String] :status Returns check runs with the specified status. Can be one of queued, in_progress, or completed.
      # @option options [String] :filter Filters check runs by their completed_at timestamp. Can be one of latest (returning the most recent check runs) or all.
      # @return [Array<Sawyer::Resource>] A list of checks
      # @see https://developer.github.com/v3/checks/runs/#list-check-runs-for-a-git-reference
      def ref_checks(repo, ref, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.antiope-preview+json' if opts[:accept].nil?

        paginate "#{Repository.path repo}/commits/#{ref}/check-runs", opts
      end
    end
  end
end

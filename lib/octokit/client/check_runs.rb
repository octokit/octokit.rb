module Octokit
  class Client

    # Methods for the Check Runs API
    #
    # @see https://developer.github.com/v3/checks/runs
    module CheckRuns

      # Create a check run
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param name [String] The name of the check
      # @param head_sha [String] The SHA of the commit
      # @param options [Hash] Method options
      # @option options [String] :details_url The URL of the integrator's site that has the full details of the check.
      # @option options [String] :external_id A reference for the run on the integrator's system.
      # @option options [String] :status The current status. Can be one of queued, in_progress, or completed. Default: queued
      # @option options [String] :started_at The time that the check run began in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ.
      # @option options [String] :conclusion Required if you provide completed_at or a status of completed. The final conclusion of the check. Can be one of success, failure, neutral, cancelled, timed_out, or action_required. When the conclusion is action_required, additional details should be provided on the site specified by details_url. Note: Providing conclusion will automatically set the status parameter to completed.
      # @option options [String] :completed_at Required if you provide conclusion. The time the check completed in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ.
      # @option options [Hash] :output Check runs can accept a variety of data in the output object, including a title and summary and can optionally provide descriptive details about the run. See the output object description.
      # @option output [String] :title Required. The title of the check run.
      # @option output [String] :summary Required. The summary of the check run. This parameter supports Markdown.
      # @option output [String] :text The details of the check run. This parameter supports Markdown.
      # @option output [Array<Hash>] :annotations Adds information from your analysis to specific lines of code. Annotations are visible in GitHub's pull request UI. For details about annotations in the UI, see "About status checks". See the annotations object description for details about how to use this parameter.
      # @option annotations [String] :path Required. The path of the file to add an annotation to.
      # @option annotations [Integer] :start_line Required. The start line of the annotation.
      # @option annotations [Integer] :end_line Required. The end line of the annotation.
      # @option annotations [Integer] :start_column The start column of the annotation.
      # @option annotations [Integer] :end_column The end column of the annotation.
      # @option annotations [String] :annotation_level Required. The level of the annotation. Can be one of notice, warning, or failure.
      # @option annotations [String] :message Required. A short description of the feedback for these lines of code. The maximum size is 64 KB.
      # @option annotations [String] :title The title that represents the annotation. The maximum size is 255 characters.
      # @option annotations [String] :raw_details Details about this annotation. The maximum size is 64 KB.
      # @option output [Array<Hash>] :images Adds images to the output displayed in the GitHub pull request UI. See the images object description for details.
      # @option images [String] :alt Required. The alternative text for the image.
      # @option images [String] :image_url Required. The full URL of the image.
      # @option images [String] :caption A short image description.
      # @option options [Array<Hash>] :actions Possible further actions the integrator can perform, which a user may trigger. Each action includes a label, identifier and description. A maximum of three actions are accepted. See the actions object description.
      # @option actions [String] :label Required. The text to be displayed on a button in the web UI. The maximum size is 20 characters.
      # @option actions [String] :description Required. A short explanation of what this action would do. The maximum size is 40 characters.
      # @option actions [String] :identifier Required. A reference for the action on the integrator's system. The maximum size is 20 characters.
      # @return [Sawyer::Resource] A hash representing the new check run
      # @see https://developer.github.com/v3/checks/runs/#create-a-check-run
      # @example
      #   check_run = Octokit.create_check_run('rails/rails', 'css-linter', '827efc6d56897b048c772eb4087f854f46256132')
      #   check_run.head_sha # => "827efc6d56897b048c772eb4087f854f46256132"
      #   check_run.status # => "queued"
      def create_check_run(repo, name, head_sha, options = {})
        params = { name: name, head_sha: head_sha }
        opts = ensure_api_media_type(:checks, options)
        post "#{Repository.path repo}/check-runs", opts.merge(params)
      end

      # Update a check run
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param id [Integer] The check run id
      # @param options [Hash] Method options
      # @option options [String] :details_url The URL of the integrator's site that has the full details of the check.
      # @option options [String] :external_id A reference for the run on the integrator's system.
      # @option options [String] :status The current status. Can be one of queued, in_progress, or completed. Default: queued
      # @option options [String] :started_at The time that the check run began in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ.
      # @option options [String] :conclusion Required if you provide completed_at or a status of completed. The final conclusion of the check. Can be one of success, failure, neutral, cancelled, timed_out, or action_required. When the conclusion is action_required, additional details should be provided on the site specified by details_url. Note: Providing conclusion will automatically set the status parameter to completed.
      # @option options [String] :completed_at Required if you provide conclusion. The time the check completed in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ.
      # @option options [Hash] :output Check runs can accept a variety of data in the output object, including a title and summary and can optionally provide descriptive details about the run. See the output object description.
      # @option output [String] :title Required. The title of the check run.
      # @option output [String] :summary Required. The summary of the check run. This parameter supports Markdown.
      # @option output [String] :text The details of the check run. This parameter supports Markdown.
      # @option output [Array<Hash>] :annotations Adds information from your analysis to specific lines of code. Annotations are visible in GitHub's pull request UI. For details about annotations in the UI, see "About status checks". See the annotations object description for details about how to use this parameter.
      # @option annotations [String] :path Required. The path of the file to add an annotation to.
      # @option annotations [Integer] :start_line Required. The start line of the annotation.
      # @option annotations [Integer] :end_line Required. The end line of the annotation.
      # @option annotations [Integer] :start_column The start column of the annotation.
      # @option annotations [Integer] :end_column The end column of the annotation.
      # @option annotations [String] :annotation_level Required. The level of the annotation. Can be one of notice, warning, or failure.
      # @option annotations [String] :message Required. A short description of the feedback for these lines of code. The maximum size is 64 KB.
      # @option annotations [String] :title The title that represents the annotation. The maximum size is 255 characters.
      # @option annotations [String] :raw_details Details about this annotation. The maximum size is 64 KB.
      # @option output [Array<Hash>] :images Adds images to the output displayed in the GitHub pull request UI. See the images object description for details.
      # @option images [String] :alt Required. The alternative text for the image.
      # @option images [String] :image_url Required. The full URL of the image.
      # @option images [String] :caption A short image description.
      # @option options [Array<Hash>] :actions Possible further actions the integrator can perform, which a user may trigger. Each action includes a label, identifier and description. A maximum of three actions are accepted. See the actions object description.
      # @option actions [String] :label Required. The text to be displayed on a button in the web UI. The maximum size is 20 characters.
      # @option actions [String] :description Required. A short explanation of what this action would do. The maximum size is 40 characters.
      # @option actions [String] :identifier Required. A reference for the action on the integrator's system. The maximum size is 20 characters.
      # @return [Sawyer::Resource] A hash representing the updated check run
      # @see https://developer.github.com/v3/checks/runs/#update-a-check-run
      # @example
      #   check_run = Octokit.update_check_run('rails/rails', 1, status: 'completed')
      #   check_run.head_sha # => "827efc6d56897b048c772eb4087f854f46256132"
      #   check_run.status # => "queued"
      def update_check_run(repo, id, options = {})
        opts = ensure_api_media_type(:checks, options)
        patch "#{Repository.path repo}/check-runs/#{id}", opts
      end

      # List check runs for a specific ref
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param ref [String] A SHA, branch name, or a tag name
      # @param options [Hash] Method options
      # @option options [String] :check_name Returns check runs with the specified name.
      # @option options [String] :status Returns check runs with the specified status. Can be one of queued, in_progress, or completed.
      # @option options [String] :filter Filters check runs by their completed_at timestamp. Can be one of latest (returning the most recent check runs) or all. Default: latest
      # @return [Array<Sawyer::Resource>] Array of check runs
      # @see https://developer.github.com/v3/checks/runs/#list-check-runs-for-a-specific-ref
      # @example
      #   Octokit.check_runs('rails/rails', 'branch or sha' state: 'closed')
      def check_runs(repo, ref, options = {})
        opts = ensure_api_media_type(:checks, options)
        paginate "#{Repository.path repo}/commits/#{ref}/check-runs", opts
      end

      # List check runs for a check suite
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param id [Integer] The check suite id
      # @param options [Hash] Method options
      # @option options [String] :check_name Returns check runs with the specified name.
      # @option options [String] :status Returns check runs with the specified status. Can be one of queued, in_progress, or completed.
      # @option options [String] :filter Filters check runs by their completed_at timestamp. Can be one of latest (returning the most recent check runs) or all. Default: latest
      # @return [Array<Sawyer::Resource>] Array of check runs
      # @see https://developer.github.com/v3/checks/runs/#list-check-runs-in-a-check-suite
      # @example
      #   Octokit.check_runs('rails/rails', 1, state: 'closed')
      def check_runs(repo, id, options = {})
        opts = ensure_api_media_type(:checks, options)
        paginate "#{Repository.path repo}/check-suites/#{id}/check-runs", opts
      end

      # Get a single check run
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param id [Fixnum] The check run id
      # @return [Sawyer::Resource] A check run
      # @see https://developer.github.com/v3/checks/runs/#get-a-single-check-run
      # @example
      #   Octokit.check_run('rails/rails', 1)
      def check_run(repo, id, options = {})
        opts = ensure_api_media_type(:checks, options)
        get "#{Repository.path repo}/check-runs/#{id}", opts
      end

      # List annotations for a check run
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param id [Fixnum] The check run id
      # @return [Array<Sawyer::Resource>] An array of annotations
      # @see https://developer.github.com/v3/checks/runs/#list-annotations-for-a-check-run
      # @example
      #   Octokit.check_run_annotations('rails/rails', 1)
      def check_run_annotations(repo, id, options = {})
        opts = ensure_api_media_type(:checks, options)
        get "#{Repository.path repo}/check-runs/#{id}/annotations", opts
      end
    end
  end
end

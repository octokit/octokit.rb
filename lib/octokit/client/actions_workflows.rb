# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Actions Workflows API
    #
    # @see https://developer.github.com/v3/actions/workflows
    module ActionsWorkflows
      # Get the workflows in a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      #
      # @return [Sawyer::Resource] the total count and an array of workflows
      # @see https://developer.github.com/v3/actions/workflows/#list-repository-workflows
      def workflows(repo, options = {})
        paginate "#{Repository.path repo}/actions/workflows", options do |data, last_response|
          data.workflows.concat last_response.data.workflows
        end
      end
      alias list_workflows workflows

      # Get single workflow in a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param id [Integer, String] Id or file name of the workflow
      #
      # @return [Sawyer::Resource] A single workflow
      # @see https://developer.github.com/v3/actions/workflows/#get-a-workflow
      def workflow(repo, id, options = {})
        get "#{Repository.path repo}/actions/workflows/#{id}", options
      end

      # Create a workflow dispatch event
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param id [Integer, String] Id or file name of the workflow
      # @param ref [String] A SHA, branch name, or tag name
      # @param options [Hash] Optional parameters
      # @option options [Boolean] :return_run_details Fetch run details
      #
      # @return [Boolean, Sawyer::Resource] Boolean success or run details
      # @see https://docs.github.com/en/rest/reference/actions#create-a-workflow-dispatch-event
      def workflow_dispatch(repo, id, ref, options = {})
        merged_params = options.merge({ ref: ref })
        endpoint_path = "#{Repository.path repo}/actions/workflows/#{id}/dispatches"

        wants_details = merged_params[:return_run_details]
        wants_details ? post(endpoint_path, merged_params) : boolean_from_response(:post, endpoint_path, merged_params)
      end

      # Enable a workflow
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param id [Integer, String] Id or file name of the workflow
      #
      # @return [Boolean] True if workflow was enabled, false otherwise
      # @see https://docs.github.com/en/rest/actions/workflows#enable-a-workflow
      def workflow_enable(repo, id, options = {})
        boolean_from_response :put, "#{Repository.path repo}/actions/workflows/#{id}/enable", options
      end

      # Disable a workflow
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param id [Integer, String] Id or file name of the workflow
      #
      # @return [Boolean] True if workflow was disabled, false otherwise
      # @see https://docs.github.com/en/rest/actions/workflows#disable-a-workflow
      def workflow_disable(repo, id, options = {})
        boolean_from_response :put, "#{Repository.path repo}/actions/workflows/#{id}/disable", options
      end
    end
  end
end

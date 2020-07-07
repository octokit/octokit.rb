# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the ReposDeployments API
    #
    # @see https://developer.github.com/v3/repos/deployments/
    module ReposDeployments
      # Get a deployment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param deployment_id [Integer] The ID of the deployment
      # @return [Sawyer::Resource] A single deployment
      # @see https://developer.github.com/v3/repos/deployments/#get-a-deployment
      def deployment(repo, deployment_id, options = {})
        get "#{Repository.path repo}/deployments/#{deployment_id}", options
      end

      # List deployments
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [String] :sha The SHA recorded at creation time.
      # @option options [String] :ref The name of the ref. This can be a branch, tag, or SHA.
      # @option options [String] :task The name of the task for the deployment (e.g., deploy or deploy:migrations).
      # @option options [String] :environment The name of the environment that was deployed to (e.g., staging or production).
      # @return [Array<Sawyer::Resource>] A list of deployments
      # @see https://developer.github.com/v3/repos/deployments/#list-deployments
      def deployments(repo, options = {})
        paginate "#{Repository.path repo}/deployments", options
      end

      # Create a deployment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param ref [String] The ref to deploy. This can be a branch, tag, or SHA.
      # @option options [String] :task Specifies a task to execute (e.g., deploy or deploy:migrations).
      # @option options [Boolean] :auto_merge Attempts to automatically merge the default branch into the requested ref, if it's behind the default branch.
      # @option options [Array] :required_contexts The status (https://developer.github.com/v3/repos/statuses/) contexts to verify against commit status checks. If you omit this parameter, GitHub verifies all unique contexts before creating a deployment. To bypass checking entirely, pass an empty array. Defaults to all unique contexts.
      # @option options [String] :payload JSON payload with extra information about the deployment.
      # @option options [String] :environment Name for the target deployment environment (e.g., production, staging, qa).
      # @option options [String] :description Short description of the deployment.
      # @option options [Boolean] :transient_environment Specifies if the given environment is specific to the deployment and will no longer exist at some point in the future. Default: false  Note: This parameter requires you to use the application/vnd.github.ant-man-preview+json (https://developer.github.com/v3/previews/#enhanced-deployments) custom media type. Note: This parameter requires you to use the application/vnd.github.ant-man-preview+json (https://developer.github.com/v3/previews/#enhanced-deployments) custom media type.
      # @option options [Boolean] :production_environment Specifies if the given environment is one that end-users directly interact with. Default: true when environment is production and false otherwise.  Note: This parameter requires you to use the application/vnd.github.ant-man-preview+json (https://developer.github.com/v3/previews/#enhanced-deployments) custom media type.
      # @return [Sawyer::Resource] The new deployment
      # @see https://developer.github.com/v3/repos/deployments/#create-a-deployment
      def create_deployment(repo, ref, options = {})
        opts = options.dup
        opts[:ref] = ref
        post "#{Repository.path repo}/deployments", opts
      end

      # Delete a deployment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param deployment_id [Integer] The ID of the deployment
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/repos/deployments/#delete-a-deployment
      def delete_deployment(repo, deployment_id, options = {})
        boolean_from_response :delete, "#{Repository.path repo}/deployments/#{deployment_id}", options
      end

      # Get a deployment status
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param deployment_id [Integer] The ID of the deployment
      # @param status_id [Integer] The ID of the status
      # @return [Sawyer::Resource] A single status
      # @see https://developer.github.com/v3/repos/deployments/#get-a-deployment-status
      def deployment_status(repo, deployment_id, status_id, options = {})
        get "#{Repository.path repo}/deployments/#{deployment_id}/statuses/#{status_id}", options
      end

      # List deployment statuses
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param deployment_id [Integer] The ID of the deployment
      # @return [Array<Sawyer::Resource>] A list of statuses
      # @see https://developer.github.com/v3/repos/deployments/#list-deployment-statuses
      def deployment_statuses(repo, deployment_id, options = {})
        paginate "#{Repository.path repo}/deployments/#{deployment_id}/statuses", options
      end

      # Create a deployment status
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param deployment_id [Integer] The ID of the deployment
      # @param state [String] The state of the status. Can be one of error, failure, inactive, in_progress, queued pending, or success. Note: To use the inactive state, you must provide the application/vnd.github.ant-man-preview+json (https://developer.github.com/v3/previews/#enhanced-deployments) custom media type. To use the in_progress and queued states, you must provide the application/vnd.github.flash-preview+json (https://developer.github.com/v3/previews/#deployment-statuses) custom media type. When you set a transient deployment to inactive, the deployment will be shown as destroyed in GitHub.
      # @option options [String] :target_url The target URL to associate with this status. This URL should contain output to keep the user updated while the task is running or serve as historical information for what happened in the deployment. Note: It's recommended to use the log_url parameter, which replaces target_url.
      # @option options [String] :log_url The full URL of the deployment's output. This parameter replaces target_url. We will continue to accept target_url to support legacy uses, but we recommend replacing target_url with log_url. Setting log_url will automatically set target_url to the same value. Default: ""  Note: This parameter requires you to use the application/vnd.github.ant-man-preview+json (https://developer.github.com/v3/previews/#enhanced-deployments) custom media type. Note: This parameter requires you to use the application/vnd.github.ant-man-preview+json (https://developer.github.com/v3/previews/#enhanced-deployments) custom media type.
      # @option options [String] :description A short description of the status. The maximum description length is 140 characters.
      # @option options [String] :environment Name for the target deployment environment, which can be changed when setting a deploy status. For example, production, staging, or qa. Note: This parameter requires you to use the application/vnd.github.flash-preview+json (https://developer.github.com/v3/previews/#deployment-statuses) custom media type.
      # @option options [String] :environment_url Sets the URL for accessing your environment. Default: ""  Note: This parameter requires you to use the application/vnd.github.ant-man-preview+json (https://developer.github.com/v3/previews/#enhanced-deployments) custom media type. Note: This parameter requires you to use the application/vnd.github.ant-man-preview+json (https://developer.github.com/v3/previews/#enhanced-deployments) custom media type.
      # @option options [Boolean] :auto_inactive Adds a new inactive status to all prior non-transient, non-production environment deployments with the same repository and environment name as the created status's deployment. An inactive status is only added to deployments that had a success state. Default: true  Note: To add an inactive status to production environments, you must use the application/vnd.github.flash-preview+json (https://developer.github.com/v3/previews/#deployment-statuses) custom media type.  Note: This parameter requires you to use the application/vnd.github.ant-man-preview+json (https://developer.github.com/v3/previews/#enhanced-deployments) custom media type.
      # @return [Sawyer::Resource] The new status
      # @see https://developer.github.com/v3/repos/deployments/#create-a-deployment-status
      def create_deployment_status(repo, deployment_id, state, options = {})
        opts = options.dup
        opts[:state] = state.to_s.downcase
        post "#{Repository.path repo}/deployments/#{deployment_id}/statuses", opts
      end
    end
  end
end

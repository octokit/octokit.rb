module Octokit
  class Client
    # Methods for the Deployments API
    #
    # @see https://developer.github.com/v3/repos/deployments/
    module Deployments
      # Get a single deployment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param deployment_id [Integer] The ID of the deployment
      # @return <Sawyer::Resource> A single deployment
      # @see https://developer.github.com/v3/repos/deployments/#get-a-single-deployment
      def deployment(repo, deployment_id, options = {})
        get("#{Repository.path repo}/deployments/#{deployment_id}", options)
      end

      # List deployments
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param options [String] :sha The SHA that was recorded at creation time.
      # @param options [String] :ref The name of the ref. This can be a branch, tag, or SHA.
      # @param options [String] :task The name of the task for the deployment (e.g., `deploy` or `deploy:migrations`).
      # @param options [String] :environment The name of the environment that was deployed to (e.g., `staging` or `production`).
      # @return [Array<Sawyer::Resource>] A list of deployments
      # @see https://developer.github.com/v3/repos/deployments/#list-deployments
      def deployments(repo, options = {})
        get("#{Repository.path repo}/deployments", options)
      end
      alias :list_deployments :deployments

      # Create a deployment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param ref [String] The ref to deploy. This can be a branch, tag, or SHA.
      # @param options [String] :task Specifies a task to execute (e.g., `deploy` or `deploy:migrations`).
      # @param options [Boolean] :auto_merge Attempts to automatically merge the default branch into the requested ref, if it is behind the default branch.
      # @param options [Array<string>] :required_contexts The status contexts to verify against commit status checks. If this parameter is omitted, then all unique contexts will be verified before a deployment is created. To bypass checking entirely pass an empty array. Defaults to all unique contexts.
      # @param options [String] :payload JSON payload with extra information about the deployment.
      # @param options [String] :environment Name for the target deployment environment (e.g., `production`, `staging`, `qa`).
      # @param options [String] :description Short description of the deployment.
      # @param options [Boolean] :transient_environment Specifies if the given environment is specific to the deployment and will no longer exist at some point in the future. **This parameter requires a custom media type to be specified.**
      # @param options [Boolean] :production_environment Specifies if the given environment is one that end-users directly interact with. **This parameter requires a custom media type to be specified.**
      # @return <Sawyer::Resource> The new deployment
      # @see https://developer.github.com/v3/repos/deployments/#create-a-deployment
      def create_deployment(repo, ref, options = {})
        options[:ref] = ref
        post("#{Repository.path repo}/deployments", options)
      end

      # Get a single deployment status
      #
      # @param deployment_url [String] A URL for a deployment resource.
      # @param status_id [Integer] The deployment status ID.
      # @return <Sawyer::Resource> A single deployment status
      # @see https://developer.github.com/v3/repos/deployments/#get-a-single-deployment-status
      def deployment_status(deployment_url, status_id, options = {})
        deployment = get(deployment_url, accept: options[:accept])
        get(deployment.rels[:statuses].href, options)
      end

      # List deployment statuses
      #
      # @param deployment_url [String] A URL for a deployment resource.
      # @return [Array<Sawyer::Resource>] A list of deployment statuses
      # @see https://developer.github.com/v3/repos/deployments/#list-deployment-statuses
      def deployment_statuses(deployment_url, options = {})
        deployment = get(deployment_url, accept: options[:accept])
        get(deployment.rels[:statuses].href, options)
      end
      alias :list_deployment_statuses :deployment_statuses

      # Create a deployment status
      #
      # @param deployment_url [String] A URL for a deployment resource.
      # @param state [String] The state of the status. Can be one of `error`, `failure`, `inactive`, `pending`, or `success`. **The `inactive` state requires a custom media type to be specified.**
      # @param options [String] :target_url The target URL to associate with this status. This URL should contain output to keep the user updated while the task is running or serve as historical information for what happened in the deployment.
      # @param options [String] :log_url This is functionally equivalent to `target_url`. We will continue accept `target_url` to support legacy uses, but we recommend modifying this to the new name to avoid confusion. **This parameter requires a custom media type to be specified.**
      # @param options [String] :description A short description of the status. Maximum length of 140 characters.
      # @param options [String] :environment_url Sets the URL for accessing your environment. **This parameter requires a custom media type to be specified.**
      # @param options [Boolean] :auto_inactive Adds a new `inactive` status to all non-transient, non-production environment deployments with the same repository and environment name as the created status's deployment. **This parameter requires a custom media type to be specified.**
      # @return <Sawyer::Resource> The new deployment status
      # @see https://developer.github.com/v3/repos/deployments/#create-a-deployment-status
      def create_deployment_status(deployment_url, state, options = {})
        deployment = get(deployment_url, accept: options[:accept])
        options[:state] = state.to_s.downcase
        post(deployment.rels[:statuses].href, options)
      end
    end
  end
end

module Octokit
  class Client

    # Methods for the Deployments API
    #
    # @see http://developer.github.com/v3/repos/commits/deployments/
    module Deployments

      DEPLOYMENTS_PREVIEW_MEDIA_TYPE = "application/vnd.github.cannonball-preview+json".freeze

      # List all deployments for a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of deployments
      # @see http://developer.github.com/v3/repos/deployments/#list-deployments
      def deployments(repo, options = {})
        options[:accept] ||= DEPLOYMENTS_PREVIEW_MEDIA_TYPE
        warn_deployments_preview
        get "repos/#{Repository.new(repo)}/deployments", options
      end
      alias :list_deployments :deployments

      # Create a deployment for a ref
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param ref [String] The ref to deploy
      # @option options [String] :payload Meta info about the deployment
      # @option options [String] :force Optional parameter to bypass any ahead/behind checks or commit status checks. Default: false
      # @option options [String] :auto_merge Optional parameter Optional parameter to merge the default branch into the requested deployment branch if necessary. Default: false
      # @option options [String] :description Optional short description.
      # @return [Sawyer::Resource] A deployment
      # @see http://developer.github.com/v3/repos/deployments/#create-a-deployment
      def create_deployment(repo, ref, options = {})
        options[:ref] = ref
        options[:accept] ||= DEPLOYMENTS_PREVIEW_MEDIA_TYPE
        warn_deployments_preview
        post "repos/#{Repository.new(repo)}/deployments", options
      end

      # List all statuses for a Deployment
      #
      # @param deployment_url [String] A URL for a deployment resource
      # @return [Array<Sawyer::Resource>] A list of deployment statuses
      # @see http://developer.github.com/v3/repos/deployments/#list-deployment-statuses
      def deployment_statuses(deployment_url, options = {})
        warn_deployments_preview
        deployment = get(deployment_url, :accept => DEPLOYMENTS_PREVIEW_MEDIA_TYPE)
        options[:accept] ||= DEPLOYMENTS_PREVIEW_MEDIA_TYPE
        get(deployment.rels[:statuses].href, options)
      end
      alias :list_deployment_statuses :deployment_statuses

      # Create a deployment status for a Deployment
      #
      # @param deployment_url [String] A URL for a deployment resource
      # @param state [String] The state: pending, success, failure, error
      # @return [Sawyer::Resource] A deployment status
      # @see http://developer.github.com/v3/repos/deployments/#create-a-deployment-status
      def create_deployment_status(deployment_url, state, options = {})
        warn_deployments_preview
        deployment = get(deployment_url, :accept => DEPLOYMENTS_PREVIEW_MEDIA_TYPE)
        options[:state] = state.to_s.downcase
        options[:accept] ||= DEPLOYMENTS_PREVIEW_MEDIA_TYPE
        post deployment.rels[:statuses].href, options
      end

      private

      def warn_deployments_preview
        warn <<-EOS
WARNING: The preview version of the Deployments API is not yet suitable for production use.
See the blog post for details: http://git.io/o2XZRA
EOS
      end

    end
  end
end

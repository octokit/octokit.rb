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
        options = ensure_deployments_api_media_type(options)
        deployments = get("repos/#{Repository.new(repo)}/deployments", options)

        deployments.map { |d| decode_payload_field(d) }
      end
      alias :list_deployments :deployments

      # Create a deployment for a ref
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param ref [String] The ref to deploy
      # @option options [String] :payload Meta info about the deployment
      # @option options [String] :force Optional parameter to bypass any ahead/behind checks or commit status checks. Default: false
      # @option options [String] :auto_merge Optional parameter to merge the default branch into the requested deployment branch if necessary. Default: false
      # @option options [String] :description Optional short description.
      # @return [Sawyer::Resource] A deployment
      # @see http://developer.github.com/v3/repos/deployments/#create-a-deployment
      def create_deployment(repo, ref, options = {})
        options = ensure_deployments_api_media_type(options)
        options[:ref] = ref
        deployment = post("repos/#{Repository.new(repo)}/deployments", options)

        decode_payload_field(deployment)
      end

      # List all statuses for a Deployment
      #
      # @param deployment_url [String] A URL for a deployment resource
      # @return [Array<Sawyer::Resource>] A list of deployment statuses
      # @see http://developer.github.com/v3/repos/deployments/#list-deployment-statuses
      def deployment_statuses(deployment_url, options = {})
        options = ensure_deployments_api_media_type(options)
        deployment = get(deployment_url, :accept => options[:accept])
        statuses = get(deployment.rels[:statuses].href, options)

        statuses.map { |s| decode_payload_field(s) }
      end
      alias :list_deployment_statuses :deployment_statuses

      # Create a deployment status for a Deployment
      #
      # @param deployment_url [String] A URL for a deployment resource
      # @param state [String] The state: pending, success, failure, error
      # @return [Sawyer::Resource] A deployment status
      # @see http://developer.github.com/v3/repos/deployments/#create-a-deployment-status
      def create_deployment_status(deployment_url, state, options = {})
        options = ensure_deployments_api_media_type(options)
        deployment = get(deployment_url, :accept => options[:accept])
        options[:state] = state.to_s.downcase
        status = post(deployment.rels[:statuses].href, options)

        decode_payload_field(status)
      end

      private

      def ensure_deployments_api_media_type(options = {})
        if options[:accept].nil?
          options[:accept] = DEPLOYMENTS_PREVIEW_MEDIA_TYPE
          warn_deployments_preview
        end

        options
      end

      def warn_deployments_preview
        warn <<-EOS
WARNING: The preview version of the Deployments API is not yet suitable for production use.
You can avoid this message by supplying an appropriate media type in the 'Accept' request
header. See the blog post for details: http://git.io/o2XZRA
EOS
      end

      def decode_payload_field(resource)
        if resource && payload = resource[:payload]
          begin
            resource[:payload] = Sawyer::Agent.serializer.decode(payload)
          rescue StandardError => e
            warn e.message
          end
        end

        resource
      end
    end
  end
end

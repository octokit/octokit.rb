module Octokit
  class Client

    # Methods for licenses API
    #
    module Licenses

      LICENSES_PREVIEW_MEDIA_TYPE = "application/vnd.github.drax-preview+json".freeze

      # List all licenses, or an individual license if a license name is supplied.
      #
      # @see https://developer.github.com/v3/licenses/#list-all-licenses
      # @see https://developer.github.com/v3/licenses/#get-an-individual-license
      # @param license_name [String] Supply a license name to get a particular license
      # @return [Array<Sawyer::Resource>] A list of licenses or an individual license
      # @example
      #   Octokit.licenses
      # @example
      #   Octokit.licenses 'mit'
      def licenses(license_name = '', options = {})
        options = ensure_deployments_api_media_type(options)
        if license_name == '' 
          get "licenses", options
        else
          get "licenses/#{license_name}", options
        end
      end

      # Get a repository’s license
      #
      # @see https://developer.github.com/v3/licenses/#get-a-repositorys-license
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @return [Sawyer::Resource] Repository information including its license
      # @example
      #   Octokit.license_for_repository 'octokit/octokit.rb'
      def license_for_repository(repo, options = {})
        options = ensure_deployments_api_media_type(options)
        get Repository.path(repo), options
      end

      def ensure_deployments_api_media_type(options = {})
        if options[:accept].nil?
          options[:accept] = LICENSES_PREVIEW_MEDIA_TYPE
          warn_deployments_preview
        end
        options
      end

      def warn_deployments_preview
        warn <<-EOS
WARNING: The preview version of the Deployments API is not yet suitable for production use.
You can avoid this message by supplying an appropriate media type in the 'Accept' request
header. 
EOS
      end  
    end
  end
end

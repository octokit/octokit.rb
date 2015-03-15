module Octokit
  class Client

    # Methods for licenses API
    #
    module Licenses

      LICENSES_PREVIEW_MEDIA_TYPE = "application/vnd.github.drax-preview+json".freeze

      # List all licenses
      #
      # @see https://developer.github.com/v3/licenses/#list-all-licenses
      # @return [Array<Sawyer::Resource>] A list of licenses
      # @example
      #   Octokit.licenses
      def licenses(options = {})
        options = ensure_license_api_media_type(options)
        paginate "licenses", options
      end

      # List an individual license
      #
      # @see https://developer.github.com/v3/licenses/#get-an-individual-license
      # @param license_name [String] The license name
      # @return <Sawyer::Resource> An individual license
      # @example
      #   Octokit.license 'mit'
      def license(license_name, options = {})
        options = ensure_license_api_media_type(options)
        get "licenses/#{license_name}", options
      end

      def ensure_license_api_media_type(options = {})
        if options[:accept].nil?
          options[:accept] = LICENSES_PREVIEW_MEDIA_TYPE
          warn_license_preview
        end
        options
      end

      def warn_license_preview
        warn <<-EOS
WARNING: The preview version of the License API is not yet suitable for production use.
You can avoid this message by supplying an appropriate media type in the 'Accept' request
header. 
EOS
      end  
    end
  end
end

module Octokit
  class Client

    # Methods for licenses API
    #
    module Licenses

      # List all licenses
      #
      # @see https://developer.github.com/v3/licenses/#list-all-licenses
      # @return [Array<Sawyer::Resource>] A list of licenses
      # @example
      #   Octokit.licenses
      def licenses(options = {})
        options = ensure_api_media_type(:licenses, options)
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
        options = ensure_api_media_type(:licenses, options)
        get "licenses/#{license_name}", options
      end
    end
  end
end

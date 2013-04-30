module Octokit
  class Client
    module Meta

      # Get meta information about GitHub.com, the service.
      #
      # @see http://developer.github.com/v3/meta/
      #
      # @return [Hash] Hash with meta information.
      #
      # @example Get GitHub meta information
      #   @client.github_meta
      def meta(options={})
        get "/meta", options
      end
      alias :github_meta :meta

    end
  end
end

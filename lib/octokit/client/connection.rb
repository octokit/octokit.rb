require 'faraday_middleware'
require 'faraday/response/raise_error'

module Octokit
  class Client
    # @private
    module Connection
      private

      def connection(authenticate=true, raw=false, version=2, force_urlencoded=false)

        if [1, 2].include? version
          url = "https://github.com/"
        elsif version >= 3
          url = "https://api.github.com/"
        end

        options = {
          :proxy => proxy,
          :ssl => { :verify => false },
          :url => url,
        }

        options.merge!(:params => { :access_token => oauth_token }) if oauthed? && !authenticated?

        connection = Faraday.new(options) do |builder|
          if version >= 3 && !force_urlencoded
            builder.use Faraday::Request::JSON
          else
            builder.use Faraday::Request::UrlEncoded
          end
          builder.use Faraday::Response::RaiseError
          unless raw
            builder.use Faraday::Response::Rashify
            builder.use Faraday::Response::ParseJson
          end
          builder.adapter(adapter)
        end
        connection.basic_auth authentication[:login], authentication[:password] if authenticate and authenticated?
        connection
      end
    end
  end
end

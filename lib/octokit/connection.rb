require 'faraday_middleware'
require 'faraday/response/raise_octokit_error'

module Octokit
  # @private
  module Connection
    private

    def connection(authenticate=true, raw=false, version=3, force_urlencoded=false)
      case version
      when 2
        url = "https://github.com"
      when 3
        url = "https://api.github.com"
      end

      options = {
        :proxy => proxy,
        :ssl => { :verify => false },
        :url => url,
      }

      options.merge!(:params => {:access_token => oauth_token}) if oauthed? && !authenticated?

      connection = Faraday.new(options) do |builder|
        if version >= 3 && !force_urlencoded
          builder.request :json
        else
          builder.request :url_encoded
        end
        builder.use Faraday::Response::RaiseOctokitError
        unless raw
          builder.use FaradayMiddleware::Mashify
          builder.use FaradayMiddleware::ParseJson
        end
        builder.adapter(adapter)
      end
      connection.basic_auth authentication[:login], authentication[:password] if authenticate and authenticated?
      connection
    end
  end
end

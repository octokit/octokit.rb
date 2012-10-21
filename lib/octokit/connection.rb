require 'faraday_middleware'
require 'faraday/response/raise_octokit_error'

module Octokit
  # @private
  module Connection
    private

    def connection(authenticate=true, raw=false, version=3, force_urlencoded=false, media_type=:json)
      case version
      when 3
        url = Octokit.api_endpoint
      end

      options = {
        :ssl => { :verify => false },
        :url => url,
      }

      options[:proxy] = proxy unless proxy.nil?

      options.merge!(:params => {:access_token => oauth_token}) if oauthed? && !authenticated?
      options.merge!(:params => unauthed_rate_limit_params) if !oauthed? && !authenticated? && unauthed_rate_limited?

      # TODO: Don't build on every request
      connection = Faraday.new(options) do |builder|
        if version >= 3 && !force_urlencoded
          builder.request :json
        else
          builder.request :url_encoded
        end

        builder.use Faraday::Response::RaiseOctokitError
        builder.use FaradayMiddleware::Mashify

        if media_type == :json
          builder.use FaradayMiddleware::ParseJson
        end

        faraday_config_block.call(builder) if faraday_config_block

        builder.adapter *adapter
      end

      connection.basic_auth authentication[:login], authentication[:password] if authenticate and authenticated?
      connection
    end
  end
end

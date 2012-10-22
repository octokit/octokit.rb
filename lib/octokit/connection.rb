require 'faraday_middleware'
require 'faraday/response/raise_octokit_error'

module Octokit
  # @private
  module Connection
    private

    def connection(options={})
      options = {
        :authenticate => true,
        :force_urlencoded => false,
        :raw => false,
        :ssl => { :verify => false },
        :url => Octokit.api_endpoint,
        :version => Octokit.api_version
      }.merge(options)

      if !proxy.nil?
        options.merge!(:proxy => proxy)
      end

      if oauthed? && !authenticated?
        options.merge!(:params => {:access_token => oauth_token})
      end

      if !oauthed? && !authenticated? && unauthed_rate_limited?
        options.merge!(:params => unauthed_rate_limit_params)
      end

      # TODO: Don't build on every request
      connection = Faraday.new(options) do |builder|
        if options[:version] >= 3 && !options[:force_urlencoded]
          builder.request :json
        else
          builder.request :url_encoded
        end

        builder.use Faraday::Response::RaiseOctokitError
        builder.use FaradayMiddleware::Mashify

        if options[:media_type][:param] != 'raw'
          builder.use FaradayMiddleware::ParseJson
        end

        faraday_config_block.call(builder) if faraday_config_block

        builder.adapter *adapter
      end

      if options[:authenticate] and authenticated?
        connection.basic_auth authentication[:login], authentication[:password]
      end

      connection
    end
  end
end

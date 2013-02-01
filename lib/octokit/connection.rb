require 'faraday_middleware'
require 'faraday/response/raise_octokit_error'

module Octokit
  # @private
  module Connection
    private

    def connection(options={})
      options = {
        :authenticate     => true,
        :force_urlencoded => false,
        :raw              => false,
        :ssl              => { :verify => false }
      }.merge(options)

      if !proxy.nil?
        options.merge!(:proxy => proxy)
      end

      if !oauthed? && !authenticated? && unauthed_rate_limited?
        options.merge!(:params => unauthed_rate_limit_params)
      end

      # TODO: Don't build on every request
      connection = Faraday.new(options) do |builder|

        if options[:force_urlencoded]
          builder.request :url_encoded
        else
          builder.request :json
        end

        builder.use Faraday::Response::RaiseOctokitError
        builder.use FaradayMiddleware::FollowRedirects
        builder.use FaradayMiddleware::Mashify

        builder.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/

        faraday_config_block.call(builder) if faraday_config_block

        builder.adapter *adapter
      end

      if options[:authenticate] and authenticated?
        connection.basic_auth authentication[:login], authentication[:password]
      end

      connection.headers[:user_agent] = user_agent

      connection
    end
  end
end

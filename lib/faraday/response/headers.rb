require 'faraday'

module Faraday
  class Response::Headers < Faraday::Middleware
    LAST_MODIFIED   = 'last-modified'.freeze
    ETAG            = 'etag'.freeze
    RATE_LIMIT      = 'x-ratelimit-limit'.freeze
    RATE_REMAINING  = 'x-ratelimit-remaining'.freeze

    def call(env)
      @app.call(env).tap do |response|
        next unless response.body
        response.body.instance_eval do
          define_singleton_method :last_modified do
            response.headers[LAST_MODIFIED]
          end

          define_singleton_method :etag do
            response.headers[ETAG]
          end

          define_singleton_method :rate_limit do
            response.headers[RATE_LIMIT].to_i
          end

          define_singleton_method :rate_remaining do
            response.headers[RATE_REMAINING].to_i
          end
        end
      end
    end
  end
end

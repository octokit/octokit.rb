# frozen_string_literal: true

require 'faraday'

module Octokit
  module Middleware
    # Resolve credentials for each request, including requests through Sawyer relations.
    class Authorization < Faraday::Middleware
      def initialize(app, authorization)
        super(app)
        @authorization = authorization
      end

      def call(env)
        # Preserve explicit headers, including FollowRedirects' cross-host guard.
        unless env.request_headers['Authorization']
          authorization = @authorization.call
          env.request_headers['Authorization'] = authorization if authorization
        end
        @app.call(env)
      end
    end
  end
end

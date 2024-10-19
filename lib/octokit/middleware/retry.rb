# frozen_string_literal: true

module Octokit
  module Middleware
    base = if defined?(Faraday::Request::Retry)
             Faraday::Request::Retry
           else
             require 'faraday/retry'
             Faraday::Retry::Middleware
           end

    # Public: Retries each request a limited number of times.
    class Retry < base
      def initialize(app, **kwargs)
        super(app, **kwargs, exceptions: DEFAULT_EXCEPTIONS + [Octokit::ServerError])
      end
    end
  end
end

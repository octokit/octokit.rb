# frozen_string_literal: true

module Octokit
  module Middleware
    if defined?(Faraday::Request::Retry)
      class Retry < Faraday::Request::Retry; end
    else
      require 'faraday/retry'
      class Retry < Faraday::Retry::Middleware; end
    end

    # Public: Retries each request a limited number of times.
    class Retry
      def initialize(app, **kwargs)
        super(app, **kwargs, exceptions: DEFAULT_EXCEPTIONS + [Octokit::ServerError])
      end
    end
  end
end

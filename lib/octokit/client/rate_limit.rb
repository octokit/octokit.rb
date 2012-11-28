module Octokit
  class Client
    module RateLimit

      def ratelimit(options={})
        headers = request(:get, "rate_limit", options).headers
        return headers["X-RateLimit-Limit"].to_i
      end
      alias rate_limit ratelimit

      def ratelimit_remaining(options={})
        headers = request(:get, "rate_limit", options).headers
        return headers["X-RateLimit-Remaining"].to_i
      end
      alias rate_limit_remaining ratelimit_remaining

    end
  end
end


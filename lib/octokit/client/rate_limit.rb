module Octokit
  class Client
    module RateLimit

      def rate_limit(options={})
        return rate_limit! if last_response.nil?

        Octokit::RateLimit.from_response(last_response)
      end
      alias ratelimit rate_limit

      def rate_limit_remaining(options={})
        puts "Deprecated: Please use .rate_limit.remaining"
        rate_limit.remaining
      end
      alias ratelimit_remaining rate_limit_remaining

      def rate_limit!(options={})
        get("/rate_limit")
        Octokit::RateLimit.from_response(last_response)
      end
      alias ratelimit! rate_limit!

      def rate_limit_remaining!(options={})
        puts "Deprecated: Please use .rate_limit!.remaining"
        rate_limit!.remaining
      end
      alias ratelimit_remaining! rate_limit_remaining!


    end
  end
end


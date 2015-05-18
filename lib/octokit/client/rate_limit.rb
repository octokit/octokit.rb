module Octokit
  class Client

    # Methods for API rate limiting info
    #
    # @see https://developer.github.com/v3/#rate-limiting
    module RateLimit

      # Get rate limit info from previous rate limit request
      # or make a new request to fetch rate limit
      #
      # @see https://developer.github.com/v3/rate_limit/#rate-limit
      # @return [Octokit::RateLimit] Rate limit info
      def rate_limit(options = {})
        @rate_limit || rate_limit!
      end
      alias ratelimit rate_limit

      # Get number of rate limted requests remaining
      #
      # @see https://developer.github.com/v3/rate_limit/#rate-limit
      # @return [Fixnum] Number of requests remaining in this period
      def rate_limit_remaining(options = {})
        octokit_warn "Deprecated: Please use .rate_limit.remaining"
        rate_limit.remaining
      end
      alias ratelimit_remaining rate_limit_remaining

      # Refresh rate limit info by making a new request
      #
      # @see https://developer.github.com/v3/rate_limit/#rate-limit
      # @return [OpenStruct] Rate limit info
      def rate_limit!(options = {})
        response = get "rate_limit"
        core_limit = Octokit::RateLimit.from_response(response, :core)
        search_limit = Octokit::RateLimit.from_response(response, :search)
        @rate_limit = OpenStruct.new({:core => core_limit, :search => search_limit}.merge!(core_limit.to_h))
      end
      alias ratelimit! rate_limit!

      # Refresh rate limit info and get number of rate limted requests remaining
      #
      # @see https://developer.github.com/v3/rate_limit/#rate-limit
      # @return [Fixnum] Number of requests remaining in this period
      def rate_limit_remaining!(options = {})
        octokit_warn "Deprecated: Please use .rate_limit!.remaining"
        rate_limit!.remaining
      end
      alias ratelimit_remaining! rate_limit_remaining!

    end
  end
end


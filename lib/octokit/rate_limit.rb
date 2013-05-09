module Octokit

  # Class for API Rate Limit info
  #
  # @see http://developer.github.com/v3/#rate-limiting
  class RateLimit < Struct.new :limit, :remaining

    # Get rate limit info from HTTP response
    #
    # @param response [#headers] HTTP response
    # @return [RateLimit]
    def self.from_response(response)
      info = new
      if response && !response.headers.nil?
        info.limit = response.headers['X-RateLimit-Limit'].to_i
        info.remaining = response.headers['X-RateLimit-Remaining'].to_i
      end

      info
    end
  end
end

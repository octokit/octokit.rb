module Octokit

  # Class for API Rate Limit info
  #
  # @!attribute [w] limit
  #   @return [Fixnum] Max tries per rate limit period
  # @!attribute [w] remaining
  #   @return [Fixnum] Remaining tries per rate limit period
  # @!attribute [w] resets_at
  #   @return [Time] Indicates when rate limit resets
  # @!attribute [w] resets_in
  #   @return [Fixnum] Number of seconds when rate limit resets
  #
  # @see https://developer.github.com/v3/#rate-limiting
  class RateLimit < Struct.new(:limit, :remaining, :resets_at, :resets_in)

    # Get rate limit info from HTTP response
    #
    # @param response [#headers] HTTP response
    # @return [RateLimit]
    def self.from_response(response)
      info = new
      if response && !response.headers.nil?
        info.limit = (response.headers['X-RateLimit-Limit'] || 1).to_i
        info.remaining = (response.headers['X-RateLimit-Remaining'] || 1).to_i
        info.resets_at = Time.at((response.headers['X-RateLimit-Reset'] || Time.now).to_i)
        info.resets_in = (info.resets_at - Time.now).to_i
      end

      info
    end
  end
end

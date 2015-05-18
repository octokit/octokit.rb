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
    # @param response [Sawyer::Resource] HTTP response
    # @param resource [Symbol] The resource in question; i.e., core or search
    # @return [RateLimit]
    def self.from_response(response, resource = :core)
      info = new
      if response && rate = response.resources.public_send(resource)
        info.limit = (rate.limit || 1).to_i
        info.remaining = (rate.remaining || 1).to_i
        info.resets_at = Time.at((rate.reset || Time.now).to_i)
        info.resets_in = [(info.resets_at - Time.now).to_i, 0].max
      end

      info
    end

    def as_hash
      return to_h if respond_to? :to_h
      each_pair.inject({}) do |hash, pair|
        hash[pair.first] = pair.last
        hash
      end
    end
  end
end

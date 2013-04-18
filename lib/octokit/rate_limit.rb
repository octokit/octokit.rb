module Octokit
  class RateLimit < Struct.new :limit, :remaining

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

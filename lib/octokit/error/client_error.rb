require 'octokit/error'

module Octokit
  class Error
    # Raised when Octokit returns a 4xx HTTP status code or there's an error in Faraday
    class ClientError < Octokit::Error
    end
  end
end

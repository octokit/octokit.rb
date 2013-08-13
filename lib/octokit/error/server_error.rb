require 'octokit/error'

module Octokit
  class Error
    # Raised when Octokit returns a 5xx HTTP status code
    class ServerError < Octokit::Error
    end
  end
end

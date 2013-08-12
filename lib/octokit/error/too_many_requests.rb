require 'twitter/error/client_error'

module Octokit
  class Error
    # Raised when Octokit returns the HTTP status code 429
    class TooManyRequests < Octokit::Error::ClientError
    end
  end
end

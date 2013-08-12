require 'octokit/error/server_error'

module Octokit
  class Error
    # Raised when Octokit returns the HTTP status code 503
    class ServiceUnavailable < Octokit::Error::ServerError
      HTTP_STATUS_CODE = 503
    end
  end
end

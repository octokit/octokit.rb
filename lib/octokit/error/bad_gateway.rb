require 'octokit/error/server_error'

module Octokit
  class Error
    # Raised when Octokit returns the HTTP status code 502
    class BadGateway < Octokit::Error::ServerError
      HTTP_STATUS_CODE = 502
    end
  end
end

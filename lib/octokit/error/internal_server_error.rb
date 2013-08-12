require 'octokit/error/server_error'

module Octokit
  class Error
    # Raised when Octokit returns the HTTP status code 500
    class InternalServerError < Octokit::Error::ServerError
      HTTP_STATUS_CODE = 500
    end
  end
end

require 'octokit/error/client_error'

module Octokit
  class Error
    # Raised when Octokit returns the HTTP status code 404
    class NotFound < Octokit::Error::ClientError
      HTTP_STATUS_CODE = 404
    end
  end
end

require 'octokit/error/client_error'

module Octokit
  class Error
    # Raised when Octokit returns the HTTP status code 400
    class BadRequest < Octokit::Error::ClientError
      HTTP_STATUS_CODE = 400
    end
  end
end

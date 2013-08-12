require 'octokit/error/client_error'

module Octokit
  class Error
    # Raised when Octokit returns the HTTP status code 422
    class UnprocessableEntity < Octokit::Error::ClientError
      HTTP_STATUS_CODE = 422
    end
  end
end

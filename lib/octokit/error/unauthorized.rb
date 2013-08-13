require 'octokit/error/client_error'

module Octokit
  class Error
    # Raised when Octokit returns the HTTP status code 401
    class Unauthorized < Octokit::Error::ClientError
      HTTP_STATUS_CODE = 401
    end
  end
end

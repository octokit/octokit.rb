require 'octokit/error/client_error'

module Octokit
  class Error
    # Raised when Octokit returns the HTTP status code 403
    class Forbidden < Octokit::Error::ClientError
      HTTP_STATUS_CODE = 403
    end
  end
end

require 'octokit/error/client_error'

module Octokit
  class Error
    # Raised when Octokit returns the HTTP status code 406
    class NotAcceptable < Octokit::Error::ClientError
      HTTP_STATUS_CODE = 406
    end
  end
end

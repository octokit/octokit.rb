require 'octokit/error/server_error'

module Octokit
  class Error
    # Raised when Octokit returns the HTTP status code 504
    class GatewayTimeout < Octokit::Error::ServerError
      HTTP_STATUS_CODE = 504
    end
  end
end

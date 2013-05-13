require 'faraday'
require 'octokit/error'

module Octokit
  # Faraday response middleware
  module Response
    class RaiseError < Faraday::Response::Middleware

      # Status code to error mappings
      # @private
      ERROR_MAP = {
        400 => Octokit::BadRequest,
        401 => Octokit::Unauthorized,
        403 => Octokit::Forbidden,
        404 => Octokit::NotFound,
        406 => Octokit::NotAcceptable,
        422 => Octokit::UnprocessableEntity,
        500 => Octokit::InternalServerError,
        501 => Octokit::NotImplemented,
        502 => Octokit::BadGateway,
        503 => Octokit::ServiceUnavailable
      }

      private

      def on_complete(response)
        key = response[:status].to_i
        raise ERROR_MAP[key].new(response) if ERROR_MAP.has_key? key
      end
    end
  end
end

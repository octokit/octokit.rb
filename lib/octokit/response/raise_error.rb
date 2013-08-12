require 'faraday'
require 'octokit/error/bad_gateway'
require 'octokit/error/bad_request'
require 'octokit/error/forbidden'
require 'octokit/error/gateway_timeout'
require 'octokit/error/internal_server_error'
require 'octokit/error/not_acceptable'
require 'octokit/error/not_found'
require 'octokit/error/service_unavailable'
require 'octokit/error/unauthorized'
require 'octokit/error/unprocessable_entity'

module Octokit
  # Faraday response middleware
  module Response

    # This class raises an Octokit-flavored exception based 
    # HTTP status codes returned by the API
    class RaiseError < Faraday::Response::Middleware

      def on_complete(env)
        status_code = env[:status].to_i
        error_class = @klass.errors[status_code]
        raise error_class.from_response(env) if error_class
      end

      def initialize(app, klass)
        @klass = klass
        super(app)
      end

    end
  end
end

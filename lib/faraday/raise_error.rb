require 'faraday'

# @api private
module Faraday
  class Response::RaiseError < Response::Middleware
    def self.register_on_complete(env)
      env[:response].on_complete do |response|
        case response[:status].to_i
        when 400
          raise Octopussy::BadRequest, error_message(response)
        when 401
          raise Octopussy::Unauthorized, error_message(response)
        when 403
          raise Octopussy::Forbidden, error_message(response)
        when 404
          raise Octopussy::NotFound, error_message(response)
        when 406
          raise Octopussy::NotAcceptable, error_message(response)
        when 500
          raise Octopussy::InternalServerError, error_message(response)
        when 501
          raise Octopussy::NotImplemented, error_message(response)
        when 502
          raise Octopussy::BadGateway, error_message(response)
        when 503
          raise Octopussy::ServiceUnavailable, error_message(response)
        end
      end
    end

    def initialize(app)
      super
    end

    private

    def self.error_message(response)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{response[:status]}#{(': ' + response[:body]) if response[:body]}"
    end
  end
end

require 'faraday'

# @api private
module Faraday
  class Response::RaiseError < Response::Middleware
    def on_complete(response)
      case response[:status].to_i
      when 400
        raise Octokit::BadRequest, error_message(response)
      when 401
        raise Octokit::Unauthorized, error_message(response)
      when 403
        raise Octokit::Forbidden, error_message(response)
      when 404
        raise Octokit::NotFound, error_message(response)
      when 406
        raise Octokit::NotAcceptable, error_message(response)
      when 500
        raise Octokit::InternalServerError, error_message(response)
      when 501
        raise Octokit::NotImplemented, error_message(response)
      when 502
        raise Octokit::BadGateway, error_message(response)
      when 503
        raise Octokit::ServiceUnavailable, error_message(response)
      end
    end

    def error_message(response)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{response[:status]}#{(': ' + response[:body]) if response[:body]}"
    end
  end
end

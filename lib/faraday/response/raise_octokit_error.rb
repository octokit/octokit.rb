require 'faraday'
require 'multi_json'

# @api private
module Faraday
  class Response::RaiseOctokitError < Response::Middleware
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

    def on_complete(response)
      key = response[:status].to_i
      raise ERROR_MAP[key], error_message(response) if ERROR_MAP.has_key? key
    end

    def error_message(response)
      message = if (body = response[:body]) && !body.empty?
        if body.is_a?(String)
          body = MultiJson.load(body, :symbolize_keys => true)
        end
        ": #{body[:error] || body[:message] || ''}"
      else
        ''
      end
      errors = unless message.empty?
        body[:errors] ?  ": #{body[:errors].map{|e|e[:message]}.join(', ')}" : ''
      end
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{response[:status]}#{message}#{errors}"
    end
  end
end

module Octokit
  # Custom error class for rescuing from all GitHub errors
  class Error < StandardError
    def initialize(response=nil)
      @response = response
      super(build_error_message)
    end

    def response_body
      @response_body ||=
        if (body = @response[:body]) && !body.empty?
          if body.is_a?(String)
            MultiJson.load(body, :symbolize_keys => true)
          else
            body
          end
        else
          nil
        end
    end

    private

    def build_error_message
      return nil  if @response.nil?

      message = if response_body
        ": #{response_body[:error] || response_body[:message] || ''}"
      else
        ''
      end
      errors = unless message.empty?
        response_body[:errors] ?  ": #{response_body[:errors].map{|e|e[:message]}.join(', ')}" : ''
      end
      "#{@response[:method].to_s.upcase} #{@response[:url].to_s}: #{@response[:status]}#{message}#{errors}"
    end
  end

  # Raised when GitHub returns a 400 HTTP status code
  class BadRequest < Error; end

  # Raised when GitHub returns a 401 HTTP status code
  class Unauthorized < Error; end

  # Raised when GitHub returns a 403 HTTP status code
  class Forbidden < Error; end

  # Raised when GitHub returns a 404 HTTP status code
  class NotFound < Error; end

  # Raised when GitHub returns a 406 HTTP status code
  class NotAcceptable < Error; end

  # Raised when GitHub returns a 422 HTTP status code
  class UnprocessableEntity < Error; end

  # Raised when GitHub returns a 500 HTTP status code
  class InternalServerError < Error; end

  # Raised when GitHub returns a 501 HTTP status code
  class NotImplemented < Error; end

  # Raised when GitHub returns a 502 HTTP status code
  class BadGateway < Error; end

  # Raised when GitHub returns a 503 HTTP status code
  class ServiceUnavailable < Error; end
end

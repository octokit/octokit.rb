require 'octokit/rate_limit'

module Octokit
  # Custom error class for rescuing from all Octokit errors
  class Error < StandardError
    attr_reader :rate_limit, :wrapped_exception

    # Create a new error from an HTTP response
    #
    # @param response [Hash]
    # @return [Octokit::Error]
    def self.from_response(response = {})
      error = parse_message(response)
      new(error, response[:response_headers])
    end

    # @return [Hash]
    def self.errors
      @errors ||= descendants.each_with_object({}) do |klass, hash|
        hash[klass::HTTP_STATUS_CODE] = klass
      end
    end

    # @return [Array]
    def self.descendants
      @descendants ||= []
    end

    # @return [Array]
    def self.inherited(descendant)
      descendants << descendant
    end

    # Initializes a new Error object
    #
    # @param exception [Exception, String]
    # @param response_headers [Hash]
    # @return [Octokit::Error]
    def initialize(exception=$!, response_headers={})
      # @rate_limit = Octokit::RateLimit.new(response_headers)
      @wrapped_exception = exception
      exception.respond_to?(:backtrace) ? super(exception.message) : super(exception.to_s)
    end

    def backtrace
      @wrapped_exception.respond_to?(:backtrace) ? @wrapped_exception.backtrace : super
    end

    private

    def self.parse_body(body)
      return nil if body.nil?

      serializer = Sawyer::Serializer.new(Sawyer::Serializer.any_json)
      data = serializer.decode(body)
    end

    def self.parse_message(response)
      body = parse_body(response[:body])

      message = if body
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

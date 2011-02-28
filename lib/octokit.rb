require File.expand_path('../octokit/configuration', __FILE__)
require File.expand_path('../octokit/client', __FILE__)

module Octokit
  extend Configuration

  # Alias for Octokit::Client.new
  #
  # @return [Octokit::Client]
  def self.client(options={})
    Octokit::Client.new(options)
  end

  # Delegate to Octokit::Client.new
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  def self.respond_to?(method)
    client.respond_to?(method) || super
  end

  # Custom error class for rescuing from all GitHub errors
  class Error < StandardError; end

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

  # Raised when GitHub returns a 500 HTTP status code
  class InternalServerError < Error; end

  # Raised when GitHub returns a 501 HTTP status code
  class NotImplemented < Error; end

  # Raised when GitHub returns a 502 HTTP status code
  class BadGateway < Error; end

  # Raised when GitHub returns a 503 HTTP status code
  class ServiceUnavailable < Error; end
end

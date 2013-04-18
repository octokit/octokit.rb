require 'sawyer'
require 'octokit/configurable'
require 'octokit/rate_limit'
require 'octokit/client/rate_limit'


module Octokit
  class Client
    include Octokit::Configurable
    include Octokit::Client::RateLimit

    attr_reader :last_response

    def initialize(options={})
      # Use options passed in, but fall back to module defaults
      Octokit::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Octokit.instance_variable_get(:"@#{key}"))
      end
    end

    def same_options?(requested_options)
      requested_options.hash == options.hash
    end

    def inspect
      inspected = super

      # Mask passwords
      inspected = inspected.gsub(/(password)="(\w+)(",)/) { "#{$1}=\"*******#{$3}" }
      # Only show last 4 of tokens, secrets
      inspected = inspected.gsub(/(access_token|client_secret)="(\w+)(",)/) { "#{$1}=\"#{"*"*36}#{$2[36..-1]}#{$3}" }

      inspected
    end

    def get(url, options = {})
      request :get, url, options
    end

    def post(url, options = {})
      request :post, url, options
    end

    def put(url, options = {})
      request :put, url, options
    end

    def patch(url, options = {})
      request :patch, options
    end

    def delete(url, options = {})
      request :delete, options
    end

    def head(url, options = {})
      request :head, options
    end

    private

    def agent
      @agent ||= Sawyer::Agent.new(api_endpoint, sawyer_options)
    end

    def request(method, url, options)
      @last_response = agent.call(method, url, options)
    end


    def sawyer_options
      { :links_parser => Sawyer::LinkParsers::Simple.new }
    end

  end
end

require 'sawyer'
require 'octokit/configurable'

module Octokit
  class Client
    include Octokit::Configurable

    def initialize(options={})
      # Use options passed in, but fall back to module defaults
      Octokit::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Octokit.instance_variable_get(:"@#{key}"))
      end
    end

    def agent
      @agent ||= Sawyer::Agent.new(api_endpoint, sawyer_options)
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

    private

    def sawyer_options
      { :links_parser => Sawyer::LinkParsers::Simple.new }
    end

  end
end

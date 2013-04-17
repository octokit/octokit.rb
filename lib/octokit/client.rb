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

    def same_options?(requested_options)
      requested_options.hash == options.hash
    end
  end
end

require File.expand_path('../event', __FILE__)
require File.expand_path('../repository', __FILE__)
Dir[File.expand_path('../client/*.rb', __FILE__)].each{|file| require file}

module Octopussy
  class Client
    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    def initialize(options={})
      options = Octopussy.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    include Octopussy::Client::Connection
    include Octopussy::Client::Request

    include Octopussy::Client::Commits
    include Octopussy::Client::Issues
    include Octopussy::Client::Network
    include Octopussy::Client::Objects
    include Octopussy::Client::Organizations
    include Octopussy::Client::Repositories
    include Octopussy::Client::Timelines
    include Octopussy::Client::Users
  end
end

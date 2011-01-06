require File.expand_path('../event', __FILE__)
require File.expand_path('../repository', __FILE__)
Dir[File.expand_path('../client/*.rb', __FILE__)].each{|file| require file}

module Octokit
  class Client
    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    def initialize(options={})
      options = Octokit.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    include Octokit::Client::Authentication
    include Octokit::Client::Connection
    include Octokit::Client::Request

    include Octokit::Client::Commits
    include Octokit::Client::Issues
    include Octokit::Client::Network
    include Octokit::Client::Objects
    include Octokit::Client::Organizations
    include Octokit::Client::Pulls
    include Octokit::Client::Repositories
    include Octokit::Client::Timelines
    include Octokit::Client::Users
  end
end

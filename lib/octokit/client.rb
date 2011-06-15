require 'octokit/connection'
require 'octokit/repository'
require 'octokit/request'

require 'octokit/client/authentication'
require 'octokit/client/commits'
require 'octokit/client/issues'
require 'octokit/client/network'
require 'octokit/client/milestones'
require 'octokit/client/objects'
require 'octokit/client/organizations'
require 'octokit/client/pub_sub_hub_bub'
require 'octokit/client/pub_sub_hub_bub/service_hooks'
require 'octokit/client/pulls'
require 'octokit/client/repositories'
require 'octokit/client/timelines'
require 'octokit/client/users'

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
    include Octokit::Client::Milestones
    include Octokit::Client::Objects
    include Octokit::Client::Organizations
    include Octokit::Client::Pulls
    include Octokit::Client::PubSubHubBub
    include Octokit::Client::PubSubHubBub::ServiceHooks
    include Octokit::Client::Repositories
    include Octokit::Client::Timelines
    include Octokit::Client::Users
  end
end

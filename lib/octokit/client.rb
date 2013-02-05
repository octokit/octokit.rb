require 'octokit/authentication'
require 'octokit/connection'
require 'octokit/gist'
require 'octokit/repository'
require 'octokit/request'

require 'octokit/client/commits'
require 'octokit/client/downloads'
require 'octokit/client/gists'
require 'octokit/client/issues'
require 'octokit/client/labels'
require 'octokit/client/milestones'
require 'octokit/client/objects'
require 'octokit/client/organizations'
require 'octokit/client/pub_sub_hubbub'
require 'octokit/client/pub_sub_hubbub/service_hooks'
require 'octokit/client/pulls'
require 'octokit/client/repositories'
require 'octokit/client/users'
require 'octokit/client/events'
require 'octokit/client/notifications'
require 'octokit/client/authorizations'
require 'octokit/client/refs'
require 'octokit/client/contents'
require 'octokit/client/markdown'
require 'octokit/client/emojis'
require 'octokit/client/statuses'
require 'octokit/client/say'
require 'octokit/client/rate_limit'
require 'octokit/client/gitignore'
require 'octokit/client/github'

module Octokit
  class Client
    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)

    def initialize(options={})
      options = Octokit.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end

      login_and_password_from_netrc(options[:netrc])
    end

    include Octokit::Authentication
    include Octokit::Connection
    include Octokit::Request

    include Octokit::Client::Commits
    include Octokit::Client::Downloads
    include Octokit::Client::Gists
    include Octokit::Client::Issues
    include Octokit::Client::Labels
    include Octokit::Client::Milestones
    include Octokit::Client::Objects
    include Octokit::Client::Organizations
    include Octokit::Client::Pulls
    include Octokit::Client::PubSubHubbub
    include Octokit::Client::PubSubHubbub::ServiceHooks
    include Octokit::Client::Repositories
    include Octokit::Client::Users
    include Octokit::Client::Events
    include Octokit::Client::Notifications
    include Octokit::Client::Authorizations
    include Octokit::Client::Refs
    include Octokit::Client::Contents
    include Octokit::Client::Markdown
    include Octokit::Client::Emojis
    include Octokit::Client::Statuses
    include Octokit::Client::Say
    include Octokit::Client::RateLimit
    include Octokit::Client::Gitignore
    include Octokit::Client::GitHub
  end
end

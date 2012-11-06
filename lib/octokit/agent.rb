require 'sawyer'

module Octokit
  module Agent
    def agent
      agent = Sawyer::Agent.new(Octokit.api_endpoint, :allow_undefined_methods => true) do |http|
        http.headers['user-agent']   = Octokit.user_agent
        http.headers['content-type'] = 'application/json'
        http.headers['Authorization'] = "token #{oauth_token}" if oauthed?
        http.basic_auth authentication[:login], authentication[:password] if authenticated? and !oauthed?
      end

      agent.links_parser = Octokit::Halogen.new

      agent
    end

    def root
      agent.start.data
    end
  end
end

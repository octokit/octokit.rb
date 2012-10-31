require 'sawyer'

module Octokit
  module Agent
    def agent
      agent = Sawyer::Agent.new(Octokit.api_endpoint) do |http|
        http.headers['content-type'] = 'application/json'
        http.basic_auth authentication[:login], authentication[:password]
      end

      agent
    end
  end
end

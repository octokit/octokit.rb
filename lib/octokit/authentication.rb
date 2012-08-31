module Octokit
  module Authentication
    def authentication
      if login && password
        {:login => login, :password => password}
      else
        {}
      end
    end

    def authenticated?
      !authentication.empty?
    end

    def oauthed?
      !oauth_token.nil?
    end

    def unauthed_rate_limited?
      client_id && client_secret
    end

    def unauthed_rate_limit_params
      {
        :client_id => client_id,
        :client_secret => client_secret
      }
    end
  end
end

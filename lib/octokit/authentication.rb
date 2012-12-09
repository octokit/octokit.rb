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

    def login_and_password_from_netrc(rc = false)
      return unless rc

      info = case rc
              when TrueClass
                Netrc.read
              when String
                Netrc.read rc
              end
      netrc_host = URI.parse(api_endpoint).host
      creds = info[netrc_host]
      self.login = creds.shift
      self.password = creds.shift
    end
  end
end

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

    # Get the url to authorize a user for an application.
    #
    # @param app_id [String] Client Id we received when our application was registered with GitHub.
    # @param app_secret [String] Client Secret we received when our application was registered with GitHub.
    # @option options [String] :redirect_uri The url to redirect to after authorizing.
    # @option options [String] :scope The scopes to request from the user.
    # @option options [String] :state A random string to protect against CSRF.
    # @return [String] The url to redirect the user to authorize.
    # @see Octokit::Client
    # @see http://developer.github.com/v3/oauth/#web-application-flow
    # @example
    #   @client.authorize_url('xxxx', 'yyyy')
    def authorize_url(app_id, app_secret, options = {})
      authorize_url = options.delete(:endpoint) || Octokit.web_endpoint
      authorize_url += "login/oauth/authorize?client_id=" + app_id + "&client_secret=" + app_secret
      
      options.each do |key, value|
        authorize_url += "&" + key.to_s + "=" + value
      end
      
      authorize_url
    end
  end
end

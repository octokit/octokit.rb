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
  end
end

module Octokit
  module Authentication

    def basic_authenticated?
      @login && @password
    end

    def token_authenticated?
      !!@access_token
    end

    def application_authenticated?
      !!application_authentication
    end

    private

    def application_authentication
      if @client_id && @client_secret
        {
          :client_id     => @client_id,
          :client_secret => @client_secret
        }
      end
    end

  end
end

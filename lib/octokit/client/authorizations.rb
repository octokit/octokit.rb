module Octokit
  class Client
    module Authorizations

      # List a users authorizations
      #
      # API for users to manage their own tokens. 
      # You can only access your own tokens, and only through 
      # Basic Authentication.
      #
      # @return [Array] A list of authorizations for the authenticated user
      # @see http://developer.github.com/v3/oauth/
      # @example List authorizations for user ctshryock
      #  client = Octokit::Client.new(:login => 'ctshryock', :password => 'secret')
      #  client.authorizations
      def authorizations
        get('/authorizations')
      end


      # Get a single authorization      
      #
      # Get a single authorization for the authenticated user
      # You can only access your own tokens, and only through 
      # Basic Authentication.
      #
      # @return [Authorization] A single authorization for the authenticated user
      # @see http://developer.github.com/v3/oauth/#get-a-single-authorization
      # @example Show authorization for user ctshryock's Travis auth
      #  client = Octokit::Client.new(:login => 'ctshryock', :password => 'secret')
      #  client.authorization(999999)
      def authorization(number)
        get("/authorizations/#{number}")
      end

    end
  end
end

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


      # Get a single authorization for the authenticated user.
      #
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

      # Create an authorization for the authenticated user.
      #
      # You can create your own tokens, and only through 
      # Basic Authentication.
      #
      # @param options [Hash] A customizable set of options.
      # @option options [Array] :scopes A list of scopes that this authorization is in.
      #   See http://developer.github.com/v3/oauth/#scopes for available scopes
      # @option options [String] :note A note to remind you what the OAuth token is for.
      # @option options [String] :note_url A URL to remind you what app the OAuth token is for.
      #
      # @return [Authorization] A single authorization for the authenticated user
      # @see http://developer.github.com/v3/oauth/#create-a-new-authorization
      # @example Create a new authorization for user ctshryock's project Zoidberg
      #  client = Octokit::Client.new(:login => 'ctshryock', :password => 'secret')
      #  client.create_authorization({:scopes => ["public_repo","gist"], :note => "Why not Zoidberg?", :note_url=> "https://en.wikipedia.org/wiki/Zoidberg"})
      def create_authorization(options={})
        options = {:scopes => ""}.merge(options)
        post('/authorizations', options)
      end

    end
  end
end

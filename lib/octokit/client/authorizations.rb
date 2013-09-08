module Octokit
  class Client

    # Methods for the Authorizations API
    #
    # @see http://developer.github.com/v3/oauth/#oauth-authorizations-api
    module Authorizations

      # List the authenticated user's authorizations
      #
      # API for users to manage their own tokens.
      # You can only access your own tokens, and only through
      # Basic Authentication.
      #
      # @return [Array<Sawyer::Resource>] A list of authorizations for the authenticated user
      # @see http://developer.github.com/v3/oauth/#list-your-authorizations
      # @example List authorizations for user ctshryock
      #  client = Octokit::Client.new(:login => 'ctshryock', :password => 'secret')
      #  client.authorizations
      def authorizations(options = {})
        paginate 'authorizations', options
      end

      # Get a single authorization for the authenticated user.
      #
      # You can only access your own tokens, and only through
      # Basic Authentication.
      #
      # @return [Sawyer::Resource] A single authorization for the authenticated user
      # @see http://developer.github.com/v3/oauth/#get-a-single-authorization
      # @example Show authorization for user ctshryock's Travis auth
      #  client = Octokit::Client.new(:login => 'ctshryock', :password => 'secret')
      #  client.authorization(999999)
      def authorization(number, options = {})
        get "authorizations/#{number}", options
      end

      # Create an authorization for the authenticated user.
      #
      # You can create your own tokens, and only through
      # Basic Authentication.
      #
      # @param options [Hash] A customizable set of options.
      # @option options [Array] :scopes A list of scopes that this authorization is in.
      # @option options [String] :note A note to remind you what the OAuth token is for.
      # @option options [String] :note_url A URL to remind you what app the OAuth token is for.
      # @option options [Boolean] :idempotent If true, will return an existing authorization if one has already been created.
      # @option options [String] :client_id  Client Id we received when our application was registered with GitHub.
      # @option options [String] :client_id  Client Secret we received when our application was registered with GitHub.
      #
      # @return [Sawyer::Resource] A single authorization for the authenticated user
      # @see http://developer.github.com/v3/oauth/#scopes Available scopes
      # @see http://developer.github.com/v3/oauth/#create-a-new-authorization
      # @example Create a new authorization for user ctshryock's project Zoidberg
      #  client = Octokit::Client.new(:login => 'ctshryock', :password => 'secret')
      #  client.create_authorization({:scopes => ["public_repo","gist"], :note => "Why not Zoidberg?", :note_url=> "https://en.wikipedia.org/wiki/Zoidberg"})
      # @example Create a new OR return an existing authorization to be used by a specific client for user ctshryock's project Zoidberg
      #  client = Octokit::Client.new(:login => 'ctshryock', :password => 'secret')
      #  client.create_authorization({:idempotent => true, :client_id => 'xxxx', :client_secret => 'yyyy', :scopes => ["user"]})
      def create_authorization(options = {})
        # Techincally we can omit scopes as GitHub has a default, however the
        # API will reject us if we send a POST request with an empty body.

        if options.delete :idempotent
          client_id, client_secret = fetch_client_id_and_secret(options)
          raise ArgumentError.new("Client ID and Secret required for idempotent authorizations") unless client_id && client_secret

          put "authorizations/clients/#{client_id}", options.merge(:client_secret => client_secret)
        else
          post 'authorizations', options
        end
      end

      # Update an authorization for the authenticated user.
      #
      # You can update your own tokens, but only through
      # Basic Authentication.
      #
      # @param options [Hash] A customizable set of options.
      # @option options [Array] :scopes Replace the authorization scopes with these.
      # @option options [Array] :add_scopes A list of scopes to add to this authorization.
      # @option options [Array] :remove_scopes A list of scopes to remove from this authorization.
      # @option options [String] :note A note to remind you what the OAuth token is for.
      # @option options [String] :note_url A URL to remind you what app the OAuth token is for.
      #
      # @return [Sawyer::Resource] A single (updated) authorization for the authenticated user
      # @see http://developer.github.com/v3/oauth/#update-a-new-authorization
      # @see http://developer.github.com/v3/oauth/#scopes for available scopes
      # @example Update the authorization for user ctshryock's project Zoidberg
      #  client = Octokit::Client.new(:login => 'ctshryock', :password => 'secret')
      #  client.update_authorization(999999, {:add_scopes => ["gist", "repo"], :note => "Why not Zoidberg possibly?"})
      def update_authorization(number, options = {})
        patch "authorizations/#{number}", options
      end

      # Delete an authorization for the authenticated user.
      #
      # You can delete your own tokens, and only through
      # Basic Authentication.
      #
      # @param number [Number] An existing Authorization ID
      #
      # @return [Boolean] Success
      # @see http://developer.github.com/v3/oauth/#delete-an-authorization
      # @example Delete an authorization
      #  client = Octokit::Client.new(:login => 'ctshryock', :password => 'secret')
      #  client.delete_authorization(999999)
      def delete_authorization(number, options = {})
        boolean_from_response :delete, "authorizations/#{number}", options
      end

      # Check scopes for a token
      #
      # @param token [String] GitHub OAuth token
      # @return [Array<String>] OAuth scopes
      # @see http://developer.github.com/v3/oauth/#scopes
      def scopes(token = @access_token)
        raise ArgumentError.new("Access token required") if token.nil?

        agent.call(:get, "user", :headers => {"Authorization" => "token #{token}" }).
          headers['X-OAuth-Scopes'].
          to_s.
          split(',').
          map(&:strip).
          sort
      end

    end

    # Get the URL to authorize a user for an application via the web flow
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

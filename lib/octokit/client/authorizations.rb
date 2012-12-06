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
      # @see http://developer.github.com/v3/oauth/#list-your-authorizations
      # @example List authorizations for user ctshryock
      #  client = Octokit::Client.new(:login => 'ctshryock', :password => 'secret')
      #  client.authorizations
      def authorizations(options={})
        get 'authorizations', options
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
      def authorization(number, options={})
        get "authorizations/#{number}", options
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
        # Techincally we can omit scopes as GitHub has a default, however the
        # API will reject us if we send a POST request with an empty body.
        options = {:scopes => ""}.merge(options)
        post('authorizations', options)
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
      # @return [Authorization] A single (updated) authorization for the authenticated user
      # @see http://developer.github.com/v3/oauth/#update-a-new-authorization
      # @see http://developer.github.com/v3/oauth/#scopes for available scopes
      # @example Update the authorization for user ctshryock's project Zoidberg
      #  client = Octokit::Client.new(:login => 'ctshryock', :password => 'secret')
      #  client.create_authorization({:add_scopes => ["gist", "repo"], :note => "Why not Zoidberg possibly?"})
      def update_authorization(number, options={})
        # Techincally we can omit scopes as GitHub has a default, however the
        # API will reject us if we send a POST request with an empty body.
        options = {:scopes => ""}.merge(options)
        patch("authorizations/#{number}", options)
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
      def delete_authorization(number, option={})
        boolean_from_response(:delete, "authorizations/#{number}")
      end

      # Check scopes for a token
      #
      # @param token [String] GitHub OAuth token
      # @return [Array<String>] OAuth scopes
      # @see http://developer.github.com/v3/oauth/#scopes
      def scopes(token=nil)
        request(:get, "user", :access_token => token).
          headers[:x_oauth_scopes].
          split(',').
          map(&:strip).
          sort
      end

    end
  end
end

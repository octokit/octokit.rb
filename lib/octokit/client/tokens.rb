# frozen_string_literal: true

module Octokit
  class Client
    # Method to check scopes and create_authorization required to test it
    #
    # @see https://developer.github.com/v3/oauth_authorizations/#oauth-authorizations-api
    module Tokens
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
      # @option options [String] :client_secret  Client Secret we received when our application was registered with GitHub.
      #
      # @return [Sawyer::Resource] A single authorization for the authenticated user
      # @see https://developer.github.com/v3/oauth/#scopes Available scopes
      # @see https://developer.github.com/v3/oauth_authorizations/#create-a-new-authorization
      # @see https://developer.github.com/v3/oauth_authorizations/#get-or-create-an-authorization-for-a-specific-app
      # @example Create a new authorization for user ctshryock's project Zoidberg
      #  client = Octokit::Client.new(:login => 'ctshryock', :password => 'secret')
      #  client.create_authorization({:scopes => ["public_repo", "gist"], :note => "Why not Zoidberg?", :note_url=> "https://en.wikipedia.org/wiki/Zoidberg"})
      # @example Create a new OR return an existing authorization to be used by a specific client for user ctshryock's project Zoidberg
      #  client = Octokit::Client.new(:login => 'ctshryock', :password => 'secret')
      #  client.create_authorization({:idempotent => true, :client_id => 'xxxx', :client_secret => 'yyyy', :scopes => ["user"]})
      def create_authorization(options = {})
        # Technically we can omit scopes as GitHub has a default, however the
        # API will reject us if we send a POST request with an empty body.
        options = options.dup
        if options.delete :idempotent
          client_id, client_secret = fetch_client_id_and_secret(options)
          unless client_id && client_secret
            raise ArgumentError, 'Client ID and Secret required for idempotent authorizations'
          end

          # Remove the client_id from the body otherwise
          # this will result in a 422.
          options.delete(:client_id)

          if (fingerprint = options.delete(:fingerprint))
            put "authorizations/clients/#{client_id}/#{fingerprint}", options.merge(client_secret: client_secret)
          else
            put "authorizations/clients/#{client_id}", options.merge(client_secret: client_secret)
          end

        else
          post 'authorizations', options
        end
      end

      # Check scopes for a token
      #
      # @param token [String] GitHub OAuth token
      # @param options [Hash] Header params for request
      # @return [Array<String>] OAuth scopes
      # @see https://developer.github.com/v3/oauth/#scopes
      def scopes(token = @access_token, options = {})
        options = options.dup
        raise ArgumentError, 'Access token required' if token.nil?

        auth = { 'Authorization' => "token #{token}" }
        headers = (options.delete(:headers) || {}).merge(auth)

        agent.call(:get, 'user', headers: headers)
             .headers['X-OAuth-Scopes']
             .to_s
             .split(',')
             .map(&:strip)
             .sort
      end
    end
  end
end

# frozen_string_literal: true

require 'openssl'
require 'json'
require 'base64'
require 'time'

module Octokit
  # Authentication methods for GitHub App credentials.
  #
  # Provides automatic JWT generation from an app_id + private_key,
  # and automatic installation access token management when
  # installation_id is also provided.
  #
  # @see https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app
  module AppAuthentication
    # Indicates if the client is configured for GitHub App authentication
    #
    # @return [Boolean]
    def app_authenticated?
      !!(@app_id && @private_key)
    end

    # Indicates if the client is configured for GitHub App installation authentication
    #
    # @return [Boolean]
    def installation_authenticated?
      app_authenticated? && !!@installation_id
    end

    # Generate or return the current JWT for the GitHub App.
    #
    # The JWT is cached and automatically regenerated when it
    # approaches expiry.
    #
    # @return [String] JWT bearer token
    def generate_app_jwt
      ensure_app_jwt_fresh!
      @bearer_token
    end

    private

    # Ensures app authentication tokens are fresh before a request.
    # Called automatically before each API request when app credentials
    # are configured.
    def ensure_app_tokens_fresh!
      return unless app_authenticated?

      if installation_authenticated?
        ensure_installation_token_fresh!
      else
        ensure_app_jwt_fresh!
      end
    end

    # Regenerates the JWT if it's expired or not yet created.
    def ensure_app_jwt_fresh!
      return if @jwt_expires_at && Time.now < @jwt_expires_at

      now = Time.now.to_i
      payload = {
        iat: now - 60, # 60 seconds in the past for clock drift
        exp: now + (10 * 60), # 10 minute maximum
        iss: @app_id.to_s
      }

      @bearer_token = build_jwt(payload, resolved_private_key)
      @jwt_expires_at = Time.at(now + (8 * 60)) # Refresh after 8 minutes
      reset_agent
    end

    # Refreshes the installation access token if expired or not yet created.
    def ensure_installation_token_fresh!
      return if @installation_token_expires_at && Time.now < @installation_token_expires_at

      # Ensure we have a fresh JWT first
      ensure_app_jwt_fresh!

      # Use a temporary JWT-authenticated client to create the installation token
      jwt_client = Octokit::Client.new(
        bearer_token: @bearer_token,
        api_endpoint: api_endpoint
      )
      token_data = jwt_client.create_app_installation_access_token(@installation_id)
      @access_token = token_data.token

      # Parse expiry and add a 2-minute buffer for safety
      expires_at = token_data.expires_at
      expires_at = Time.parse(expires_at.to_s) unless expires_at.is_a?(Time)
      @installation_token_expires_at = expires_at - 120

      reset_agent
    end

    # Resolves the private_key configuration into an OpenSSL::PKey::RSA object.
    # Supports PEM-encoded strings and pre-parsed RSA key objects.
    def resolved_private_key
      @resolved_private_key ||= case @private_key
                                when OpenSSL::PKey::RSA
                                  @private_key
                                when String
                                  OpenSSL::PKey::RSA.new(@private_key)
                                else
                                  raise ArgumentError,
                                        'private_key must be a PEM-encoded String or OpenSSL::PKey::RSA object'
                                end
    end

    # Builds a JWT signed with RS256.
    #
    # @param payload [Hash] JWT claims (iat, exp, iss)
    # @param private_key [OpenSSL::PKey::RSA] Signing key
    # @return [String] Encoded JWT
    def build_jwt(payload, private_key)
      header = { alg: 'RS256', typ: 'JWT' }

      segments = [
        Base64.urlsafe_encode64(JSON.generate(header), padding: false),
        Base64.urlsafe_encode64(JSON.generate(payload), padding: false)
      ]

      signing_input = segments.join('.')
      signature = private_key.sign(OpenSSL::Digest::SHA256.new, signing_input)
      segments << Base64.urlsafe_encode64(signature, padding: false)

      segments.join('.')
    end
  end
end

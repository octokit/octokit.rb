# frozen_string_literal: true

require 'openssl'
require 'json'
require 'base64'
require 'time'
require 'octokit/error'

module Octokit
  # Authentication methods for GitHub App credentials.
  #
  # @see https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app
  module AppAuthentication
    # @return [Boolean] Whether GitHub App credentials are configured
    def app_authenticated?
      authentication_value_present?(@app_id) && authentication_value_present?(@private_key)
    end

    # @return [Boolean] Whether GitHub App installation credentials are configured
    def installation_authenticated?
      app_authenticated? && authentication_value_present?(@installation_id)
    end

    # Generate or return the cached JWT for the GitHub App.
    #
    # @return [String] JWT bearer token
    def generate_app_jwt
      raise Octokit::AppAuthenticationError, 'app_id and private_key are required to generate a GitHub App JWT' unless app_authenticated?

      @app_credentials.jwt
    end

    private

    def reset_app_authentication
      @app_credentials = if app_authenticated?
                           Credentials.new(
                             @app_id, @private_key,
                             installation_authenticated? ? @installation_id : nil,
                             method(:exchange_installation_token)
                           )
                         end
      reset_agent
    end

    def app_authorization
      @app_credentials&.authorization
    end

    def exchange_installation_token(installation_id, jwt)
      build_agent(authorization: "Bearer #{jwt}")
        .call(:post, "app/installations/#{installation_id}/access_tokens", {}).data
    end

    def authentication_value_present?(value)
      !!value && (!value.respond_to?(:empty?) || !value.empty?)
    end

    # Private, per-client credential cache. Configuration changes replace it.
    class Credentials
      def initialize(app_id, private_key, installation_id, exchange)
        @app_id = app_id
        @private_key = private_key
        @installation_id = installation_id
        @exchange = exchange
        @mutex = Mutex.new
      end

      def jwt
        @mutex.synchronize { current_jwt }
      end

      def authorization
        @mutex.synchronize do
          @installation_id ? "token #{installation_token}" : "Bearer #{current_jwt}"
        end
      end

      def inspect
        "#<#{self.class}>"
      end

      private

      def current_jwt
        return @jwt if @jwt_expires_at && Time.now < @jwt_expires_at

        now = Time.now.to_i
        payload = { iat: now - 60, exp: now + 600, iss: @app_id.to_s }
        @jwt = build_jwt(payload)
        @jwt_expires_at = Time.at(now + 480)
        @jwt
      end

      def installation_token
        return @token if @token_expires_at && Time.now < @token_expires_at

        data = @exchange.call(@installation_id, current_jwt)
        unless data.respond_to?(:token) && data.token.is_a?(String) && !data.token.empty? &&
               data.respond_to?(:expires_at) && data.expires_at
          raise Octokit::AppAuthenticationError,
                'GitHub App installation token response must include token and expires_at'
        end

        expires_at = parse_expiry(data.expires_at)
        @token = data.token
        @token_expires_at = expires_at - 120
        @token
      end

      def parse_expiry(value)
        value.is_a?(Time) ? value : Time.iso8601(value.to_s)
      rescue ArgumentError
        raise Octokit::AppAuthenticationError, 'Invalid installation token expires_at'
      end

      def resolved_private_key
        @resolved_private_key ||= begin
          key = case @private_key
                when OpenSSL::PKey::RSA
                  @private_key
                when String
                  OpenSSL::PKey::RSA.new(@private_key)
                else
                  raise Octokit::AppAuthenticationError,
                        'private_key must be a PEM-encoded String or OpenSSL::PKey::RSA object'
                end
          raise Octokit::AppAuthenticationError, 'GitHub App private key must include a private key' unless key.private?

          key
        end
      rescue OpenSSL::PKey::RSAError => e
        raise Octokit::AppAuthenticationError, "Invalid GitHub App private key: #{e.message}"
      end

      def build_jwt(payload)
        segments = [
          Base64.urlsafe_encode64(JSON.generate(alg: 'RS256', typ: 'JWT'), padding: false),
          Base64.urlsafe_encode64(JSON.generate(payload), padding: false)
        ]
        signature = resolved_private_key.sign(OpenSSL::Digest.new('SHA256'), segments.join('.'))
        segments << Base64.urlsafe_encode64(signature, padding: false)
        segments.join('.')
      end
    end
    private_constant :Credentials
  end
end

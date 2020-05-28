# frozen_string_literal: true

require 'faraday'

module Octokit
  module Middleware
    # Public: Encode the response body to match the
    # Content-Type header.
    #
    # This is handled differently depending on the
    # HTTP adapter.
    #
    # See https://github.com/lostisland/faraday/issues/139
    # for more details.
    class CharacterEncoding < Faraday::Response::Middleware
      # Helper class to decode
      # https://developer.github.com/v3/media/#media-types
      class MediaType
        attr_reader :response_headers

        CHARSET = /charset=([^ ]+)/.freeze
        FORMAT  = /format=([^ ]+)/.freeze
        PARAM   = /param=([^ ]+)/.freeze

        def initialize(response_headers)
          @response_headers = response_headers
        end

        def encoding_reported?
          !reported_encoding.empty?
        end

        def reported_encoding
          return @reported_encoding if defined?(@reported_encoding)

          @reported_encoding = ''
          return @reported_encoding unless content_type.include?('charset=')

          @reported_encoding = content_type.match(/charset=([^ ]+)/)[1]
        end

        def param
          return @param if defined?(@param)

          @param = ''
          return @param unless x_github_media_type.include?('param=')

          @param = x_github_media_type.match(/param=([^ ]+)/)[1].tr(';', '')
        end

        def format
          return @format if defined?(@format)

          @format = ''
          return @format unless x_github_media_type.include?('format=')

          @format = x_github_media_type.match(/format=([^ ]+)/)[1].tr(';', '')
        end

        def json?
          format == 'json' || content_type.include?('application/json')
        end

        private

        def content_type
          @content_type ||= @response_headers.fetch('content-type', '')
        end

        def x_github_media_type
          @x_github_media_type ||= @response_headers.fetch('x-github-media-type', '')
        end
      end

      def on_complete(env)
        media_type = MediaType.new(env.response_headers)

        if media_type.json?
          response_body = JSON.parse(env.response_body)

          if base64_encoding?(response_body)
            response_body['content'] = Base64.decode64(response_body['content'])
            env.response_body = response_body.to_json
            return
          end
        end

        return unless media_type.encoding_reported?

        env.response_body.force_encoding(media_type.reported_encoding)
      end

      private

      def base64_encoding?(response_body)
        response_body['encoding'] == 'base64'
      end

      def content_type(env)
        env.response.headers.fetch('content-type', '')
      end

      def encoding_reported?(env)
        content_type = content_type(env)
        return false if content_type.empty?

        content_type.include?('charset') && env.response_body.is_a?(String)
      end
    end
  end
end

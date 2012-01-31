require 'faraday_middleware'
require 'faraday/response/raise_octokit_error'

module Octokit
  # @private
  module Connection
    private

    def connection(authenticate=true, raw=false, version=2, force_urlencoded=false)
      case version
      when 2
        if github_url
          url = github_url
        else
          url = "https://github.com"
        end
      when 3
        if github_url
          if github_url[/(https|http):\/\/(.*)/]
            url = "#{$1}://api.#{$2}"
          else
            url = "https://api.github.com"
          end
        else
          url = "https://api.github.com"
        end
      end

      options = {
        :proxy => proxy,
        :ssl => { :verify => false },
        :url => url,
      }

      options.merge!(:params => {:access_token => oauth_token}) if oauthed? && !authenticated?

      connection = Faraday.new(options) do |builder|
        if version >= 3 && !force_urlencoded
          builder.use Faraday::Request::JSON
        else
          builder.use Faraday::Request::UrlEncoded
        end
        builder.use Faraday::Response::RaiseOctokitError
        unless raw
          builder.use FaradayMiddleware::Mashify
          builder.use FaradayMiddleware::ParseJson
        end
        builder.adapter(adapter)
      end
      connection.basic_auth authentication[:login], authentication[:password] if authenticate and authenticated?
      connection
    end
  end
end

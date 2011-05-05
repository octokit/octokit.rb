require 'faraday_middleware'
require 'faraday/response/raise_error'

module Octokit
  class Client
    # @private
    module Connection
      private

      def connection(url, authenticate=true, raw=false)
        options = {
          :proxy => proxy,
          :ssl => {:verify => false},
          :url => url,
        }

        options.merge!(:params => { :access_token => oauth_token }) if oauthed? && !authenticated?

        con = Faraday::Connection.new(options) do |connection|
          connection.use Faraday::Request::UrlEncoded
          connection.use Faraday::Response::RaiseError
          unless raw
            connection.use Faraday::Response::Rashify
            connection.use Faraday::Response::ParseJson
          end
          connection.adapter(adapter)
        end
        con.basic_auth authentication[:login], authentication[:password] if authenticate and authenticated?
        con
      end
    end
  end
end

require 'faraday_middleware'
require 'faraday/response/raise_error'

module Octokit
  class Client
    # @private
    module Connection
      private

      def connection(authenticate=true, raw=false, version=2)
        
        if [1, 2].include? version
          url = "https://github.com/"
        elsif version >= 3
          url = "https://api.github.com/"
        end

        options = {
          :proxy => proxy,
          :ssl => {:verify => false},
          :url => url,
        }

        options.merge!(:params => { :access_token => oauth_token }) if oauthed? && !authenticated?

        con = Faraday::Connection.new(options) do |connection|
          if version >= 3
            connection.use Faraday::Request::JSON
          else 
            connection.use Faraday::Request::UrlEncoded
          end
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

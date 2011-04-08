require 'faraday_middleware'
require 'faraday/response/raise_error'

module Octokit
  class Client
    # @private
    module Connection
      private

      def connection(raw=false, authenticate=true)
        options = {
          :proxy => proxy,
          :ssl => {:verify => false},
          :url => endpoint,
        }

        options.merge!(:params => { :access_token => oauth_token }) if oauthed? && !authenticated?

        con = Faraday::Connection.new(options) do |connection|
          connection.use Faraday::Response::RaiseError
          unless raw
            connection.use Faraday::Response::Mashify
            case format.to_s.downcase
            when 'json' then connection.use Faraday::Response::ParseJson
            when 'xml' then connection.use Faraday::Response::ParseXml
            end
          end
          connection.adapter(adapter)
        end
        con.basic_auth authentication[:login], authentication[:password] if authenticate and authenticated?
        con
      end
    end
  end
end

require 'faraday_middleware'
Dir[File.expand_path('../../../faraday/*.rb', __FILE__)].each{|file| require file}

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

        Faraday::Connection.new(options) do |connection|
          connection.adapter(adapter)
          connection.basic_auth authentication[:login], authentication[:password] if authenticate and authenticated?
          connection.use Faraday::Response::RaiseError
          unless raw
            case format.to_s.downcase
            when 'json' then connection.use Faraday::Response::ParseJson
            when 'xml' then connection.use Faraday::Response::ParseXml
            end
            connection.use Faraday::Response::Mashify
          end
        end
      end
    end
  end
end

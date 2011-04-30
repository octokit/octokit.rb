module Octokit
  class Client
    module Request
      def get(path, options={}, authenticate=true, raw=false)
        request(:get, path, options, authenticate, raw)
      end

      def post(path, options={}, authenticate=true, raw=false)
        request(:post, path, options, authenticate, raw)
      end

      def put(path, options={}, authenticate=true, raw=false)
        request(:put, path, options, authenticate, raw)
      end

      def delete(path, options={}, authenticate=true, raw=false)
        request(:delete, path, options, authenticate, raw)
      end

      private

      def request(method, path, options, authenticate, raw, version=api_version)
        if [1, 2].include? api_version
          url = "https://github.com/"
        elsif api_version >= 3
          url = "https://api.github.com/"
        end
        response = connection(url, authenticate, raw).send(method) do |request|
          case method
          when :get, :delete
            request.url(path, options)
          when :post, :put
            request.path = path
            request.body = options unless options.empty?
          end
        end
        raw ? response : response.body
      end

    end
  end
end

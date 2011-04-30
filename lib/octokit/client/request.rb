module Octokit
  class Client
    module Request
      def get(path, options={}, version=api_version, authenticate=true, raw=false)
        request(:get, path, options, version, authenticate, raw)
      end

      def post(path, options={}, version=api_version, authenticate=true, raw=false)
        request(:post, path, options, version, authenticate, raw)
      end

      def put(path, options={}, version=api_version, authenticate=true, raw=false)
        request(:put, path, options, version, authenticate, raw)
      end

      def delete(path, options={}, version=api_version, authenticate=true, raw=false)
        request(:delete, path, options, version, authenticate, raw)
      end

      private

      def request(method, path, options, version, authenticate, raw)
        if [1, 2].include? version
          url = "https://github.com/"
        elsif version >= 3
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

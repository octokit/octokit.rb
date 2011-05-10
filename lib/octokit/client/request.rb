module Octokit
  class Client
    module Request
      def get(path, options={}, version=api_version, authenticate=true, raw=false)
        request(:get, path, options, version, authenticate, raw)
      end

      def post(path, options={}, version=api_version, authenticate=true, raw=false)
        request(:post, path, options, version, authenticate, raw)
      end

      def patch(path, options={}, version=api_version, authenticate=true, raw=false)
        request(:patch, path, options, version, authenticate, raw)
      end

      def put(path, options={}, version=api_version, authenticate=true, raw=false)
        request(:put, path, options, version, authenticate, raw)
      end

      def delete(path, options={}, version=api_version, authenticate=true, raw=false)
        request(:delete, path, options, version, authenticate, raw)
      end

      private

      def request(method, path, options, version, authenticate, raw)
        response = connection(authenticate, raw, version).send(method) do |request|
          case method
          when :get, :delete
            request.url(path, options)
          when :post, :patch, :put
            request.path = path
            if version >= 3
              request.body = options.to_json unless options.empty?
            else
              request.body = options unless options.empty?
            end
          end
        end
        raw ? response : response.body
      end

    end
  end
end

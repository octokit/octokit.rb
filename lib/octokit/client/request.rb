module Octokit
  class Client
    module Request
      def get(path, options={}, raw=false, authenticate=true)
        request(:get, path, options, raw, authenticate)
      end

      def post(path, options={}, raw=false, authenticate=true)
        request(:post, path, options, raw, authenticate)
      end

      def put(path, options={}, raw=false, authenticate=true)
        request(:put, path, options, raw, authenticate)
      end

      def delete(path, options={}, raw=false, authenticate=true)
        request(:delete, path, options, raw, authenticate)
      end

      private

      def request(method, path, options, raw, authenticate)
        response = connection(raw, authenticate).send(method) do |request|
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

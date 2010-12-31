module Octopussy
  class Client
    module Request
      def get(path, options={}, raw=false, format_path=true)
        request(:get, path, options, raw, format_path)
      end

      def post(path, options={}, raw=false, format_path=true)
        request(:post, path, options, raw, format_path)
      end

      def put(path, options={}, raw=false, format_path=true)
        request(:put, path, options, raw, format_path)
      end

      def delete(path, options={}, raw=false, format_path=true)
        request(:delete, path, options, raw, format_path)
      end

      private

      def request(method, path, options, raw, format_path)
        response = connection(raw).send(method) do |request|
          path = formatted_path(path) if format_path
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

      def formatted_path(path)
        ['api', ['v', version].join, format, path].compact.join('/')
      end
    end
  end
end

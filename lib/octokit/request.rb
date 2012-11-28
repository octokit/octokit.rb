require 'multi_json'

module Octokit
  module Request

    def delete(path, options={})
      request(:delete, path, options).body
    end

    def get(path, options={})
      response = request(:get, path, options)
      body = response.body

      if auto_traversal && body.is_a?(Array)
        while next_url = links(response)["next"]
          response = request(:get, next_url, options)
          body += response.body
        end
      end

      body
    end

    def patch(path, options={})
      request(:patch, path, options).body
    end

    def post(path, options={})
      request(:post, path, options).body
    end

    def put(path, options={})
      request(:put, path, options).body
    end

    def ratelimit(options={})
      headers = request(:get, "rate_limit", options).headers
      return headers["X-RateLimit-Limit"].to_i
    end
    alias rate_limit ratelimit

    def ratelimit_remaining(options={})
      headers = request(:get, "rate_limit", options).headers
      return headers["X-RateLimit-Remaining"].to_i
    end
    alias rate_limit_remaining ratelimit_remaining

    private

    def request(method, path, options={})
      path.sub(%r{^/}, '') #leading slash in path fails in github:enterprise

      response = connection.send(method) do |request|

        request.headers['Accept'] =  options.delete(:accept) || 'application/vnd.github.beta+json'

        case method
        when :get
          if auto_traversal && per_page.nil?
            self.per_page = 100
          end
          options.merge!(:per_page => per_page) if per_page
          request.url(path, options)
        when :delete
          request.url(path, options)
        when :patch, :post, :put
          request.path = path
          request.body = MultiJson.dump(options) unless options.empty?
        end

        if Octokit.request_host
          request.headers['Host'] = Octokit.request_host
        end

      end

      response
    end

    def links(response)
      links = ( response.headers["Link"] || "" ).split(', ').map do |link|
        url, type = link.match(/<(.*?)>; rel="(\w+)"/).captures
        [ type, url ]
      end

      Hash[ *links.flatten ]
    end

  end
end

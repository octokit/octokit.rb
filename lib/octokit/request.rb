require 'multi_json'

module Octokit
  module Request
    def delete(path, options={}, version=api_version, authenticate=true, raw=false, force_urlencoded=false)
      request(:delete, path, options, version, authenticate, raw, force_urlencoded)
    end

    def get(path, options={}, version=api_version, authenticate=true, raw=false, force_urlencoded=false)
      request(:get, path, options, version, authenticate, raw, force_urlencoded)
    end

    def patch(path, options={}, version=api_version, authenticate=true, raw=false, force_urlencoded=false)
      request(:patch, path, options, version, authenticate, raw, force_urlencoded)
    end

    def post(path, options={}, version=api_version, authenticate=true, raw=false, force_urlencoded=false)
      request(:post, path, options, version, authenticate, raw, force_urlencoded)
    end

    def put(path, options={}, version=api_version, authenticate=true, raw=false, force_urlencoded=false)
      request(:put, path, options, version, authenticate, raw, force_urlencoded)
    end

    def ratelimit
      headers = get("rate_limit",{}, api_version, true, true).headers
      return headers["X-RateLimit-Limit"].to_i
    end
    alias rate_limit ratelimit

    def ratelimit_remaining
      headers = get("rate_limit",{}, api_version, true, true).headers
      return headers["X-RateLimit-Remaining"].to_i
    end
    alias rate_limit_remaining ratelimit_remaining

    private

    def request(method, path, options, version, authenticate, raw, force_urlencoded)
      path.sub(%r{^/}, '') #leading slash in path fails in github:enterprise
      response = connection(authenticate, raw, version, force_urlencoded).send(method) do |request|
        case method
        when :delete, :get
          per_page = 100 if auto_traversal && per_page.nil?
          options.merge!(:per_page => per_page) if per_page

          request.url(path, options)
        when :patch, :post, :put
          request.path = path

          use_multi_json = version == 3 && !force_urlencoded
          unless options.empty?
            request.body = use_multi_json ? MultiJson.dump(options) : options
          end
        end
      end

      if raw
        response
      elsif auto_traversal && ( next_url = links(response)["next"] )
        response.body + request(method, next_url, options, version, authenticate, raw, force_urlencoded)
      else
        response.body
      end
    end

    def links(response)
      return {} unless response.headers["Link"]
      
      links = response.headers["Link"].scan(/<(.*?)>; rel="(\w+)"/)

      Hash[links.flatten].invert
    end
  end
end

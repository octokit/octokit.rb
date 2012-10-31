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
      response = agent.call(method, path) do |request|
        request.headers['Host'] = Octokit.request_host if Octokit.request_host
      end
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

require 'multi_json'

module Octokit
  module Request

    def self.request_method(http_method)
      module_eval <<-RUBY
        def #{http_method}(path, options={}, version=api_version, authenticated=true, raw=options.delete(:raw){false}, force_urlencoded=false)
          request(:#{http_method}, path, options, version, authenticated, raw, force_urlencoded)
                end
      RUBY

    end

    %w{delete get patch post put}.each do |meth|
      request_method meth
    end

    def head(path, options={}, version=api_version, authenticate=true, raw=true, force_urlencoded=false)
      request(:head, path, options, version, authenticate, true, force_urlencoded)
      # head requests are always raw because there is never a body
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
        when :delete, :get, :head
          if auto_traversal && per_page.nil?
            self.per_page = 100
          end
          options.merge!(:per_page => per_page) if per_page
          request.url(path, options)
        when :patch, :post, :put
          request.path = path
          if 3 == version && !force_urlencoded
            request.body = MultiJson.dump(options) unless options.empty?
          else
            request.body = options unless options.empty?
          end
        end

        request.headers['Host'] = Octokit.request_host if Octokit.request_host
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
      links = ( response.headers["Link"] || "" ).split(', ').map do |link|
        url, type = link.match(/<(.*?)>; rel="(\w+)"/).captures
        [ type, url ]
      end

      Hash[ *links.flatten ]
    end
  end
end

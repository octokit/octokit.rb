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

    private

    # Executes the request, checking if it was successful
    #
    # @return [Boolean] True on success, false otherwise
    def boolean_from_response(method, path, options={})
     request(method, path, options).status == 204
    rescue Octokit::NotFound
      false
    end

    def request(method, path, options={})
      path.sub(%r{^/}, '') #leading slash in path fails in github:enterprise

      token = options.delete(:access_token) ||
              options.delete(:oauth_token)  ||
              oauth_token

      force_urlencoded = options.delete(:force_urlencoded) || false

      url = options.delete(:endpoint) || api_endpoint

      conn_options = {
        :authenticate => token.nil?,
        :force_urlencoded => force_urlencoded,
        :url => url
      }

      response = connection(conn_options).send(method) do |request|

        request.headers['Accept'] =  options.delete(:accept) || 'application/vnd.github.beta+json'

        if token
          request.headers[:authorization] = "token #{token}"
        end

        case method
        when :get
          if auto_traversal && per_page.nil?
            self.per_page = 100
          end
          options.merge!(:per_page => per_page) if per_page
          request.url(path, options)
        when :delete, :head
          request.url(path, options)
        when :patch, :post, :put
          request.path = path
          if force_urlencoded
            request.body = options unless options.empty?
          else
            request.body = MultiJson.dump(options) unless options.empty?
          end
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

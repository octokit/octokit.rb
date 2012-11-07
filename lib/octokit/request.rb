require 'multi_json'

module Octokit
  module Request
    def delete(path, options={}, version=api_version, authenticate=true)
      request(:delete, path, {:query => options}, version, authenticate)
    end

    def get(path, options={}, version=api_version, authenticate=true)
      request(:get, path, {:query => options}, version, authenticate)
    end

    def patch(path, options={}, version=api_version, authenticate=true)
      request(:patch, path, options, version, authenticate)
    end

    def post(path, options={}, version=api_version, authenticate=true)
      request(:post, path, options, version, authenticate)
    end

    def put(path, options={}, version=api_version, authenticate=true)
      request(:put, path, options, version, authenticate)
    end

    private

    def request(method, path, options, version, authenticate)
      puts "Deprecated: Please use Agent or Sawyer Resource Relation -- #{method.to_s.upcase} #{path}"
      path.sub(%r{^/}, '') #leading slash in path fails in github:enterprise
      response = agent.call(method, path, options) do |request|
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

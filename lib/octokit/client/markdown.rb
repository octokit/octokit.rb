module Octokit
  class Client
    module Markdown

      # Receive the default Readme for a repository
      #
      # @param text [String] Markdown source
      # @option options [String] (optional) :mode (`markdown` or `gfm`)
      # @option options [String] (optional) :context Repo context
      # @return [String] HTML renderization
      # @see http://developer.github.com/v3/repos/markdown/
      # @example Render some GFM
      #   Octokit.markdown('Fixed in #111', :mode => "gfm", :context => "pengwynn/octokit")
      def markdown(text, options={})
        options[:text] = text
        options[:repo] = Repository.new(options[:repo]) if options[:repo]
        # TODO: move to a Faraday factory and share with Sawyer
        conn = Faraday.new(:url => Octokit.api_endpoint) do |faraday|
          faraday.headers['user-agent']   = Octokit.user_agent
          faraday.adapter :net_http
        end

        response = conn.post do |req|
          req.url 'markdown'
          req.body = options
          req.headers['Content-Type'] = 'text/x-markdown'
        end

        response.body
      end

    end
  end
end

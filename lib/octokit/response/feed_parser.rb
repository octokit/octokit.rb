require 'faraday'

module Octokit

  module Response

    # Parses RSS and Atom feed responses.
    class FeedParser < Faraday::Response::Middleware

      dependency do
        require 'rss'
      end

      private

      def on_complete(env)
        if env[:response_headers]["content-type"] =~ /(\batom|\brss)/
          env[:body] = RSS::Parser.parse env[:body]
        end
      end

    end
  end
end

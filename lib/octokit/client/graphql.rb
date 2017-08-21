module Octokit
  class Client
    module GraphQL
      def graphql(query)
        raise Octokit::TokenAuthenticationRequired unless token_authenticated?

        post "/graphql", {:query => query}.to_json
      end
    end
  end
end

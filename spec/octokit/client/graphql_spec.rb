require 'helper'

describe Octokit::Client::GraphQL do

  let(:query) { <<-eos
      {
        viewer {
          login
          bio
          organizations(first: 3) {
            edges {
              org:node {
                name
              }
            }
          }
        }
      }
    eos
  }

  describe ".graphql", :vcr do
    it "requires token authentication" do
      expect { basic_auth_client.graphql(query) }.to raise_error(Octokit::TokenAuthenticationRequired)
    end

    it "executes queries" do
      data = oauth_client.graphql(query).data

      expect(data.viewer.login).to eq("api-padawan")
    end
  end # .graphql

end

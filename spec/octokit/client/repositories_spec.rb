require 'helper'

describe Octokit::Client::Repositories do
  before do
    @request_id = fixtures_server_client.post('/fixtures', { "scenario" => "get-repository" }).id
    @test_client = Octokit::Client.new(
      :api_endpoint => "http://localhost:3000/api.github.com/#{@request_id}",
      :access_token => "0000000000000000000000000000000000000001"
    )
  end

  describe ".repository" do
    it "returns the matching repository" do
      repository = @test_client.repository("octokit-fixture-org/hello-world")
      expect(repository.name).to eq("hello-world")
      assert_requested :get, "http://localhost:3000/api.github.com/#{@request_id}/repos/octokit-fixture-org/hello-world"
    end
  end # .repository
end

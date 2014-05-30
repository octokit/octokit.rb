require 'helper'

describe Octokit::Client::Hooks do

  describe ".available_hooks", :vcr do
    it "returns all the hooks supported by GitHub with their parameters" do
      client = oauth_client
      hooks = client.available_hooks
      expect(hooks.first.name).to eq("activecollab")
    end
  end
end

# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::GitHub do

  before do
    @client = Octokit::Client.new
  end

  describe ".github_meta" do
    it "returns meta information about github" do
      stub_get("/meta").
        to_return(json_response("github_meta.json"))
      github_meta = @client.github_meta
      expect(github_meta.git.first).to eq("127.0.0.1/32")
    end
  end

end

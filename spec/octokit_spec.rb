# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit do
  after do
    Octokit.reset
  end

  describe ".respond_to?" do
    it "is true if method exists" do
      expect(Octokit.respond_to?(:new, true)).to eq(true)
    end
  end

  describe ".new" do
    it "is a Octokit::Client" do
      expect(Octokit.new).to be_a Octokit::Client
    end
  end

  describe ".delegate" do
    it "delegates missing methods to Octokit::Client" do
      stub_get("/repos/pengwynn/octokit/issues").
        to_return(json_response('issues.json'))
      issues = Octokit.issues('pengwynn/octokit')
      expect(issues.last.user.login).to eq('fellix')
    end

  end
end

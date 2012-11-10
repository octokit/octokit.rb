# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit do

  after do
    Octokit.reset
  end

  describe ".respond_to?" do
    it "is true if method exists" do
      expect(Octokit.respond_to?(:new, true)).to be_true
    end
  end

  describe ".new" do
    it "is a Octokit::Client" do
      expect(Octokit.new).to be_a Octokit::Client
    end
  end

  describe ".delegate" do
    it "delegates missing methods to Octokit::Client" do
      stub_get("https://api.github.com/").
        to_return(:body => fixture("v3/root.json"))
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_get("/repos/sferik/rails_admin/issues").
        to_return(:status => 200, :body => fixture('v3/issues.json'))
      issues = Octokit.issues('sferik/rails_admin')
      expect(issues.last.user.login).to eq('fellix')
    end

  end
end

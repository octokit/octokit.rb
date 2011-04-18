# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit do
  after do
    Octokit.reset
  end

  describe ".respond_to?" do
    it "should be true if method exists" do
      Octokit.respond_to?(:client, true).should be_true
    end
  end

  describe ".client" do
    it "should be a Octokit::Client" do
      Octokit.client.should be_a Octokit::Client
    end
  end

end

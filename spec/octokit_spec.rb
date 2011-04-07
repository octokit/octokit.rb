# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit do
  after do
    Octokit.reset
  end

  describe ".client" do
    it "should be a Octokit::Client" do
      Octokit.client.should be_a Octokit::Client
    end
  end

end

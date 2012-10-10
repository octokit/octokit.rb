# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Gist do

  context "when given a URL" do
    it "sets the id" do
      gist = Octokit::Gist.from_url("https://gist.github.com/12345")
      expect(gist.id).to eq('12345')
    end
  end

  context "when passed a string ID" do
    before do
      @gist = Octokit::Gist.new('12345')
    end

    it "sets the gist ID" do
      expect(@gist.id).to eq('12345')
    end

    it "sets the url" do
      expect(@gist.url).to eq('https://gist.github.com/12345')
    end

    it "renders id as string" do
      expect(@gist.to_s).to eq(@gist.id)
    end
  end

  context "when passed a Fixnum ID" do
    before do
      @gist = Octokit::Gist.new(12345)
    end

    it "sets the gist ID as a string" do
      expect(@gist.id).to eq('12345')
    end

    it "sets the url" do
      expect(@gist.url).to eq('https://gist.github.com/12345')
    end

    it "renders id as string" do
      expect(@gist.to_s).to eq(@gist.id)
    end
  end

end

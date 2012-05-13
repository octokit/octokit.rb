# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Gist do

  context "when given a URL" do
    it "should set the id" do
      gist = Octokit::Gist.from_url("https://gist.github.com/12345")
      gist.id.should == '12345'
    end
  end

  context "when passed a string ID" do
    before do
      @gist = Octokit::Gist.new('12345')
    end

    it "should set the gist ID" do
      @gist.id.should == '12345'
    end

    it "should set the url" do
      @gist.url.should == 'https://gist.github.com/12345'
    end

    it "should render id as string" do
      @gist.to_s.should == @gist.id
    end
  end

  context "when passed a Fixnum ID" do
    before do
      @gist = Octokit::Gist.new(12345)
    end

    it "should set the gist ID as a string" do
      @gist.id.should == '12345'
    end

    it "should set the url" do
      @gist.url.should == 'https://gist.github.com/12345'
    end

    it "should render id as string" do
      @gist.to_s.should == @gist.id
    end
  end

end

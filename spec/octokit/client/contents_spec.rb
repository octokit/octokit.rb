# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Contents do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".readme" do

    it "returns the default readme" do
      stub_get("/repos/pengwynn/octokit/readme").
        to_return(:body => fixture("v3/readme.json"))
      readme = @client.readme('pengwynn/octokit')
      expect(readme.encoding).to eq("base64")
      expect(readme.type).to eq("file")
    end

  end

  describe ".contents" do

    it "returns the contents of a file" do
      stub_get("/repos/pengwynn/octokit/contents/lib/octokit.rb").
        to_return(:body => fixture("v3/contents.json"))
      contents = @client.contents('pengwynn/octokit', :path => "lib/octokit.rb")
      expect(contents.path).to eq("lib/octokit.rb")
      expect(contents.name).to eq("lib/octokit.rb")
      expect(contents.encoding).to eq("base64")
      expect(contents.type).to eq("file")
    end

  end

  context "repo archives (weak redirection handling)"do
    before do
      stub_head("/repos/pengwynn/octokit/tarball/master").
        to_return(:status => 302, :body => '', :headers =>
                  { 'location' => "https://nodeload.github.com/repos/pengwynn/octokit/tarball/master"})

      stub_head("https://nodeload.github.com/repos/pengwynn/octokit/tarball/master").
        to_return(:status => 200, :body => '')

      stub_get("https://nodeload.github.com/repos/pengwynn/octokit/tarball/master").
        to_return(:status => 200, :body => 'these are the bits')
    end

    describe ".archive_link" do
      it "returns the URI of the specified repos archive" do
        archive_link = @client.archive_link('pengwynn/octokit', :ref => "master")
        expect(archive_link).to eq("https://nodeload.github.com/repos/pengwynn/octokit/tarball/master")
      end
    end

    describe ".archive" do
      it "returns the contents of the specified repos archive" do
        @client.archive('pengwynn/octokit', :ref => "master").tap do |archive|
          expect(archive.read).to eq("these are the bits")
        end
      end
    end
  end
end

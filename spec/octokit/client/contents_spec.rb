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

  describe ".archive_link" do

    it "returns the headers of the request" do
      stub_get("/repos/pengwynn/octokit/tarball/master").
        to_return(:status => 302, :body => '', :headers =>
          { 'location' => "https://nodeload.github.com/repos/pengwynn/octokit/tarball/"})
      archive_link = @client.archive_link('pengwynn/octokit', :ref => "master")
      expect(archive_link).to eq("https://api.github.com/repos/pengwynn/octokit/tarball/master")
    end

  end

end

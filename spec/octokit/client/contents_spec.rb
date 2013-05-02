require 'helper'

describe Octokit::Client::Contents do

  before do
    Octokit.reset!
    VCR.insert_cassette 'contents'
  end

  after do
    VCR.eject_cassette
  end

  describe ".readme" do
    it "returns the default readme" do
      readme = Octokit.readme('pengwynn/octokit')
      expect(readme.encoding).to eq "base64"
      expect(readme.type).to eq "file"
      assert_requested :get, github_url("/repos/pengwynn/octokit/readme")
    end
  end # .readme

  describe ".contents" do
    it "returns the contents of a file" do
      contents = Octokit.contents('pengwynn/octokit', :path => "lib/octokit.rb")
      expect(contents.encoding).to eq "base64"
      expect(contents.type).to eq "file"
      assert_requested :get, github_url("/repos/pengwynn/octokit/contents/lib/octokit.rb")
    end
  end # .contents

  describe ".archive_link" do
    it "returns the headers of the request" do
      archive_link = Octokit.archive_link('pengwynn/octokit', :ref => "master")
      expect(archive_link).to eq 'https://codeload.github.com/pengwynn/octokit/legacy.tar.gz/master'
      assert_requested :head, github_url("/repos/pengwynn/octokit/tarball/master")
    end
  end # .archive_link

end

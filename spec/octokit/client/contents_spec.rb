require File.expand_path('../../../spec_helper.rb', __FILE__)

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
      readme.encoding.must_equal "base64"
      readme.type.must_equal "file"
    end
  end # .readme

  describe ".contents" do
    it "returns the contents of a file" do
      contents = Octokit.contents('pengwynn/octokit', :path => "lib/octokit.rb")
      readme.encoding.must_equal "base64"
      readme.type.must_equal "file"
    end
  end # .contents

  describe ".archive_link" do
    it "returns the headers of the request" do
      archive_link = Octokit.archive_link('pengwynn/octokit', :ref => "master")
      archive_link.must_equal 'https://codeload.github.com/pengwynn/octokit/legacy.tar.gz/master'
    end
  end # .archive_link

end

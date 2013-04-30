require File.expand_path('../../../spec_helper.rb', __FILE__)

describe Octokit::Client::Meta do

  describe ".github_meta" do
    it "returns meta information about github" do
      VCR.use_cassette 'meta' do
        github_meta = Octokit.github_meta
        github_meta.git.must_include "207.97.227.239/32"
        assert_requested :get, github_url("/meta")
      end
    end
  end # .github_meta

end

require 'helper'

describe Octokit::Client::Markdown do

  before do
    Octokit.reset!
    VCR.insert_cassette 'markdown'
  end

  after do
    Octokit.reset!
    VCR.eject_cassette
  end

  describe ".markdown" do
    it "renders markdown" do
      text = "This is for #111"
      markdown = Octokit.markdown(text, :context => 'pengwynn/octokit', :mode => 'gfm')

      expect(markdown).to include 'https://github.com/pengwynn/octokit/issues/111'
      assert_requested :post, github_url('/markdown')
    end
  end # .markdown

end

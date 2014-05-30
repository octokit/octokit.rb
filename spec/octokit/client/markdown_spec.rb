require 'helper'

describe Octokit::Client::Markdown do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".markdown", :vcr do
    it "renders markdown" do
      text = "This is for #111"
      markdown = @client.markdown(text, :context => 'octokit/octokit.rb', :mode => 'gfm')

      expect(markdown).to include('https://github.com/octokit/octokit.rb/issues/111')
      assert_requested :post, github_url('/markdown')
    end
  end # .markdown

end

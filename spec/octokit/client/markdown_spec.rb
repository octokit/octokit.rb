# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Markdown do

  describe ".markdown" do

    before do
      @client = Octokit::Client.new
    end

    it "renders markdown" do
      stub_post("/markdown").
        to_return(:body => fixture("markdown_gfm"))
      text = "This is for #111"
      markdown = @client.markdown(text, :context => 'pengwynn/octokit', :mode => 'gfm')

      expect(markdown).to include('https://github.com/pengwynn/octokit/issues/111')
    end

  end

end

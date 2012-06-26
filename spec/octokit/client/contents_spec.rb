# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Contents do   

	before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

	describe ".readme" do

		it "should return the default readme" do 
			stub_get("/repos/pengwynn/octokit/readme").
				to_return(:body => fixture("v3/readme.json"))
			readme = @client.readme('pengwynn/octokit')
			readme.encoding.should == "base64"
			readme.type.should == "file"
		end

	end

	describe ".contents" do

		it "should return the contents of a file" do
			stub_get("/repos/pengwynn/octokit/contents/lib/octokit.rb").
				to_return(:body => fixture("v3/contents.json"))
			contents = @client.contents('pengwynn/octokit', :path => "lib/octokit.rb")
			contents.path.should == "lib/octokit.rb"
			contents.name.should == "lib/octokit.rb"
			contents.encoding.should == "base64"
			contents.type.should == "file"
		end

	end

	describe ".archive_link" do

		it "should return the headers of the request" do
			stub_get("/repos/pengwynn/octokit/tarball/master").
				to_return(:status => 302, :body => '', :headers => 
					{ 'location' => "https://nodeload.github.com/repos/pengwynn/octokit/tarball/"})
			archive_link = @client.archive_link('pengwynn/octokit', :ref => "master")
			archive_link == "https://nodeload.github.com/pengwynn/octokit/tarball/"
		end

	end

end
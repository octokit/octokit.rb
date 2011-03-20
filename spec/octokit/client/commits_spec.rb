require 'helper'

describe Octokit::Client::Pulls do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".commits" do

    it "should return all commits" do
      stub_get("commits/list/sferik/rails_admin/master").
        to_return(:body => fixture("commits.json"))
      commits = @client.commits("sferik/rails_admin")
      commits.first.author.login.should == "caboteria"
    end

  end

  describe ".commit" do

    it "should return a commit" do
      stub_get("commits/show/sferik/rails_admin/3cdfabd973bc3caac209cba903cfdb3bf6636bcd").
        to_return(:body => fixture("commit.json"))
      commit = @client.commit("sferik/rails_admin", "3cdfabd973bc3caac209cba903cfdb3bf6636bcd")
      commit.first.author.login.should == "caboteria"
    end

  end

end

require File.expand_path('../../../helper', __FILE__)

describe Octokit::Client::Pulls do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".create_pull_request" do

    it "should create a pull request" do
      stub_post("pulls/sferik/rails_admin").
        with(:pull => {:base => "master", :head => "pengwynn:master", :title => "Title", :body => "Body"}).
        to_return(:body => fixture("pulls.json"))
      issues = @client.create_pull_request("sferik/rails_admin", "master", "pengwynn:master", "Title", "Body")
      issues.first.number.should == 251
    end

  end

  describe ".pull_requests" do

    it "should return all pull requests" do
      stub_get("pulls/sferik/rails_admin/open").
        to_return(:body => fixture("pulls.json"))
      pulls = @client.pulls("sferik/rails_admin")
      pulls.first.number.should == 251
    end

  end

  describe ".pull_request" do

    it "should return a pull request" do
      stub_get("pulls/sferik/rails_admin/251").
        to_return(:body => fixture("pull.json"))
      pull = @client.pull("sferik/rails_admin", 251)
      pull.number.should == 251
    end

  end

end

require File.expand_path('../../../helper', __FILE__)

describe Octokit::Client::Users do

  before do
    @client = Octokit::Client.new
  end

  it "should search users by username" do
    stub_get("user/search/sferik").
      to_return(:body => fixture("users.json"))
    users = @client.search_users("sferik")
    users.first.username.should == "sferik"
  end

end

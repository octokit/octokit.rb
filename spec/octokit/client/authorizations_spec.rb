# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Authorizations do

  before do
    @client = Octokit::Client.new(:login => 'ctshryock', :password => 'secret')
  end


  it "should list existing authorizations" do
    stub_get("/authorizations").
    to_return(:body => fixture("v3/authorizations.json"))
    authorizations = @client.authorizations
    authorizations.first.app.name.should == "Calendar About Nothing" 
  end

  it "should return a single authorization" do
    stub_get("/authorizations/999999").
    to_return(:body => fixture("v3/authorization.json"))
    authorizations = @client.authorization(999999)
    authorizations.app.name.should == "Travis" 
  end

  it "should create a new authorization" do

  end

  it "should update and existing authorization" do

  end

  it "should delete an existing authorization" do

  end

  it "should scope permissions correctly" do

  end

  describe "restrictions" do

    it "should work with basic auth" do

    end

    it "should raise an error when used with OAuth" do

    end

  end

end

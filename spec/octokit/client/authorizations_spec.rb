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
    authorization = @client.authorization(999999)
    authorization.app.name.should == "Travis" 
  end

  it "should create a new default authorization" do
    stub_post('/authorizations').
      with(:body => {"scopes" => ""},
           :headers => {'Content-Type'=>'application/json'}).
      to_return(:body => fixture("v3/authorization.json"))
    authorization = @client.create_authorization
    authorization.app.name.should == "Travis" 
  end

  it "should create a new authorization with options" do
    stub_post('/authorizations').
      with(:body => {"scopes" => ["public_repo"],"note" => "admin script", "note_url" => "https://github.com/pengwynn/octokit"},
           :headers => {'Content-Type'=>'application/json'}).
      to_return(:body => fixture("v3/authorization.json"))
    authorization = @client.create_authorization({:scopes => ["public_repo"], :note => "admin script", :note_url => "https://github.com/pengwynn/octokit"})
    authorization.scopes.should include("public_repo")
  end

  it "should update and existing authorization" do
    stub_patch('/authorizations/999999').
      with(:body => {"scopes"=>"", "add_scopes" => ["public_repo", "gist"]},
           :headers => {'Content-Type'=>'application/json'}).
      to_return(:body => fixture("v3/authorization.json"))
    authorization = @client.update_authorization(999999, {:add_scopes => ['public_repo', 'gist']})
    authorization.scopes.should include("public_repo")
  end

  it "should delete an existing authorization" do
    stub_delete('/authorizations/999999').
      to_return(:status => 204)
    authorization = @client.delete_authorization(999999)
    authorization.status.should == 204
  end

end

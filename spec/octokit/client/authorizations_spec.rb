# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Authorizations do

  before do
    stub_get("https://ctshryock:secret@api.github.com/").
      to_return(:body => fixture("v3/root.json"))
    @client = Octokit::Client.new(:login => 'ctshryock', :password => 'secret')
  end


  it "lists existing authorizations" do
    stub_get("/authorizations").
      to_return(:body => fixture("v3/authorizations.json"))
    authorizations = @client.authorizations
    expect(authorizations.first.app.name).to eq("Calendar About Nothing" )
  end

  pending "returns a single authorization" do
    stub_get("/authorizations/999999").
      to_return(:body => fixture("v3/authorization.json"))
    authorization = @client.authorization(999999)
    expect(authorization.app.name).to eq("Travis" )
  end

  it "creates a new default authorization" do
    stub_post('/authorizations').
      with(:body => {"scopes" => ""},
           :headers => {'Content-Type'=>'application/json'}).
      to_return(:body => fixture("v3/authorization.json"))
    authorization = @client.create_authorization
    expect(authorization.app.name).to eq("Travis" )
  end

  pending "creates a new authorization with options" do
    stub_post('/authorizations').
      with(:body => {"scopes" => ["public_repo"],"note" => "admin script", "note_url" => "https://github.com/pengwynn/octokit"},
           :headers => {'Content-Type'=>'application/json'}).
      to_return(:body => fixture("v3/authorization.json"))
    authorization = @client.create_authorization({:scopes => ["public_repo"], :note => "admin script", :note_url => "https://github.com/pengwynn/octokit"})
    expect(authorization.scopes).to include("public_repo")
  end

  pending "updates and existing authorization" do
    stub_patch('/authorizations/999999').
      with(:body => {"scopes"=>"", "add_scopes" => ["public_repo", "gist"]},
           :headers => {'Content-Type'=>'application/json'}).
      to_return(:body => fixture("v3/authorization.json"))
    authorization = @client.update_authorization(999999, {:add_scopes => ['public_repo', 'gist']})
    expect(authorization.scopes).to include("public_repo")
  end

  pending "deletes an existing authorization" do
    stub_delete('/authorizations/999999').
      to_return(:status => 204)
    result = @client.delete_authorization(999999)
    expect(result).to be_true
  end

end

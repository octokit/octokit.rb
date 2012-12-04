# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Authorizations do

  before do
    @client = Octokit::Client.new(:login => 'ctshryock', :password => 'secret')
  end


  it "lists existing authorizations" do
    stub_get("/authorizations").
      to_return(json_response("authorizations.json"))
    authorizations = @client.authorizations
    expect(authorizations.first.app.name).to eq("Calendar About Nothing" )
  end

  it "returns a single authorization" do
    stub_get("/authorizations/999999").
      to_return(json_response("authorization.json"))
    authorization = @client.authorization(999999)
    expect(authorization.app.name).to eq("Travis" )
  end

  it "creates a new default authorization" do
    stub_post('/authorizations').
      with(:body => {"scopes" => ""},
           :headers => {'Content-Type'=>'application/json'}).
      to_return(json_response("authorization.json"))
    authorization = @client.create_authorization
    expect(authorization.app.name).to eq("Travis" )
  end

  it "creates a new authorization with options" do
    stub_post('/authorizations').
      with(:body => {"scopes" => ["public_repo"],"note" => "admin script", "note_url" => "https://github.com/pengwynn/octokit"},
           :headers => {'Content-Type'=>'application/json'}).
      to_return(json_response("authorization.json"))
    authorization = @client.create_authorization({:scopes => ["public_repo"], :note => "admin script", :note_url => "https://github.com/pengwynn/octokit"})
    expect(authorization.scopes).to include("public_repo")
  end

  it "updates and existing authorization" do
    stub_patch('/authorizations/999999').
      with(:body => {"scopes"=>"", "add_scopes" => ["public_repo", "gist"]},
           :headers => {'Content-Type'=>'application/json'}).
      to_return(json_response("authorization.json"))
    authorization = @client.update_authorization(999999, {:add_scopes => ['public_repo', 'gist']})
    expect(authorization.scopes).to include("public_repo")
  end

  it "deletes an existing authorization" do
    stub_delete('/authorizations/999999').
      to_return(:status => 204)
    result = @client.delete_authorization(999999)
    expect(result).to eq(true)
  end

  context "when working with tokens" do
    before(:each) do
      Octokit.reset
    end

    it "checks the scopes on a token" do
      stub_get("https://api.github.com/user").
        to_return \
          :status => 200,
          :body => fixture('user.json'),
          :headers => {
            :content_type => 'application/json; charset=utf-8',
            :x_oauth_scopes => 'user, gist'
          }

      client = Octokit::Client.new :oauth_token => 'abcdabcdabcdabcdabcdabcdabcdabcdabcd'
      scopes = Octokit.scopes
      expect(scopes).to eq(['gist', 'user'])
    end

    it "checks the scopes on a one-off token" do
      stub_get("https://api.github.com/user").
        to_return \
          :status => 200,
          :body => fixture('user.json'),
          :headers => {
            :content_type => 'application/json; charset=utf-8',
            :x_oauth_scopes => 'user, gist, repo'
          }

      client = Octokit::Client.new
      scopes = Octokit.scopes('abcdabcdabcdabcdabcdabcdabcdabcdabcd')
      expect(scopes).to eq(['gist', 'repo', 'user'])
    end

  end

end

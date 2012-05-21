# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Gists do

  before do
    @username = "Oshuma"
    @client = Octokit::Client.new(:login => @username)
  end

  describe ".public_gists" do
    it "should return public gists" do
      stub_get("/gists").to_return(:body => fixture("v3/public_gists.json"))
      gists = @client.public_gists
      gists.should_not be_empty
    end
  end # .public_gists

  describe ".gists" do
    context "with username passed" do
      it "should return a list of gists" do
        stub_get("/users/#{@username}/gists").
          to_return(:body => fixture("v3/gists.json"))
        gists = @client.gists(@username)
        gists.first.user.login.should == @username
      end
    end

    context "without a username passed" do
      it "should return a list of gists" do
        stub_get("/gists").to_return(:body => fixture("v3/gists.json"))
        gists = @client.gists
        gists.first.user.login.should == @username
      end
    end
  end # .gists

  describe ".starred_gists" do
    it "should return the user's starred gists" do
      stub_get("/gists/starred").to_return(:body => fixture("v3/starred_gists.json"))
      gists = @client.starred_gists
      gists.should_not be_empty
    end
  end

  describe ".gist" do
    it "should return the gist by ID" do
      stub_get("/gists/1").to_return(:body => fixture("v3/gist.json"))
      gist = @client.gist(1)
      gist.user.login.should == @username
    end
  end

  describe ".create_gist" do
    it "should create a new gist" do
      gist_content = JSON.parse(fixture("v3/gist.json").read)
      new_gist = {
        :description => gist_content['description'],
        :public      => gist_content['public'],
        :files       => gist_content['files'],
      }

      stub_post("/gists").with(new_gist).
        to_return(:body => fixture("v3/gist.json"))

      gist = @client.create_gist(new_gist)
      gist.should == gist_content
    end
  end

  describe ".edit_gist" do
    it "should edit an existing gist" do
      gist_content = JSON.parse(fixture("v3/gist.json").read)
      gist_id = gist_content['id']
      updated_gist = gist_content.merge('description' => 'updated')

      stub_patch("/gists/#{gist_id}").
        to_return(:body => updated_gist)

      gist = @client.edit_gist(gist_id, :description => 'updated')
      gist['description'].should == 'updated'
    end
  end

  describe ".star_gist" do
    it "should star an existing gist" do
      stub_put("/gists/12345/star").to_return(:status => 204)
      success = @client.star_gist(12345)
      success.should be_true
    end
  end

  describe ".unstar_gist" do
    it "should unstar an existing gist" do
      stub_delete("/gists/12345/star").to_return(:status => 204)
      success = @client.unstar_gist(12345)
      success.should be_true
    end
  end

  describe ".gist_starred?" do
    it "should be starred" do
      stub_get("/gists/12345/star").to_return(:status => 204)
      starred = @client.gist_starred?(12345)
      starred.should be_true
    end

    it "should not be starred" do
      stub_get("/gists/12345/star").to_return(:status => 404)
      starred = @client.gist_starred?(12345)
      starred.should be_false
    end
  end

  describe ".fork_gist" do
    it "should fork an existing gist" do
      stub_post("/gists/12345/fork").
        to_return(:body => fixture("v3/gist.json"))

      gist = @client.fork_gist(12345)
      gist.user.login.should == @username
    end
  end

  describe ".delete_gist" do
    it "should delete an existing gist" do
      stub_delete("/gists/12345").to_return(:status => 204)
      deleted = @client.delete_gist(12345)
      deleted.should be_true
    end
  end

end

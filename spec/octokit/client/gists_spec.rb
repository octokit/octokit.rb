# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Gists do

  before do
    @username = "Oshuma"
    @client = Octokit::Client.new(:login => @username)
  end

  describe ".public_gists" do
    it "returns public gists" do
      stub_get("/gists/public").to_return(:body => fixture("v3/public_gists.json"))
      gists = @client.public_gists
      expect(gists).not_to be_empty
    end
  end # .public_gists

  describe ".gists" do
    context "with username passed" do
      it "returns a list of gists" do
        stub_get("/users/#{@username}/gists").
          to_return(:body => fixture("v3/gists.json"))
        gists = @client.gists(@username)
        expect(gists.first.user.login).to eq(@username)
      end
    end

    context "without a username passed" do
      it "returns a list of gists" do
        stub_get("/gists").to_return(:body => fixture("v3/gists.json"))
        gists = @client.gists
        expect(gists.first.user.login).to eq(@username)
      end
    end
  end # .gists

  describe ".starred_gists" do
    it "returns the user's starred gists" do
      stub_get("/gists/starred").to_return(:body => fixture("v3/starred_gists.json"))
      gists = @client.starred_gists
      expect(gists).not_to be_empty
    end
  end

  describe ".gist" do
    it "returns the gist by ID" do
      stub_get("/gists/1").to_return(:body => fixture("v3/gist.json"))
      gist = @client.gist(1)
      expect(gist.user.login).to eq(@username)
    end
  end

  describe ".create_gist" do
    it "creates a new gist" do
      gist_content = JSON.parse(fixture("v3/gist.json").read)
      new_gist = {
        :description => gist_content['description'],
        :public      => gist_content['public'],
        :files       => gist_content['files'],
      }

      stub_post("/gists").with(new_gist).
        to_return(:body => fixture("v3/gist.json"))

      gist = @client.create_gist(new_gist)
      expect(gist).to eq(gist_content)
    end
  end

  describe ".edit_gist" do
    it "edit an existing gist" do
      gist_content = JSON.parse(fixture("v3/gist.json").read)
      gist_id = gist_content['id']
      updated_gist = gist_content.merge('description' => 'updated')

      stub_patch("/gists/#{gist_id}").
        to_return(:body => updated_gist)

      gist = @client.edit_gist(gist_id, :description => 'updated')
      expect(gist['description']).to eq('updated')
    end
  end

  describe ".star_gist" do
    it "stars an existing gist" do
      stub_put("/gists/12345/star").to_return(:status => 204)
      success = @client.star_gist(12345)
      expect(success).to be_true
    end
  end

  describe ".unstar_gist" do
    it "unstars an existing gist" do
      stub_delete("/gists/12345/star").to_return(:status => 204)
      success = @client.unstar_gist(12345)
      expect(success).to be_true
    end
  end

  describe ".gist_starred?" do
    it "is starred" do
      stub_get("/gists/12345/star").to_return(:status => 204)
      starred = @client.gist_starred?(12345)
      expect(starred).to be_true
    end

    it "is not starred" do
      stub_get("/gists/12345/star").to_return(:status => 404)
      starred = @client.gist_starred?(12345)
      expect(starred).to be_false
    end
  end

  describe ".fork_gist" do
    it "forks an existing gist" do
      stub_post("/gists/12345/fork").
        to_return(:body => fixture("v3/gist.json"))

      gist = @client.fork_gist(12345)
      expect(gist.user.login).to eq(@username)
    end
  end

  describe ".delete_gist" do
    it "deletes an existing gist" do
      stub_delete("/gists/12345").to_return(:status => 204)
      deleted = @client.delete_gist(12345)
      expect(deleted).to be_true
    end
  end

end

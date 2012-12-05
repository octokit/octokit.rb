# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Gists do

  before do
    @username = "Oshuma"
    @client = Octokit::Client.new(:login => @username)
  end

  describe ".public_gists" do
    it "returns public gists" do
      stub_get("/gists/public").to_return(json_response("public_gists.json"))
      gists = @client.public_gists
      expect(gists).not_to be_empty
    end
  end # .public_gists

  describe ".gists" do
    context "with username passed" do
      it "returns a list of gists" do
        stub_get("/users/#{@username}/gists").
          to_return(json_response("gists.json"))
        gists = @client.gists(@username)
        expect(gists.first.user.login).to eq(@username)
      end
    end

    context "without a username passed" do
      it "returns a list of gists" do
        stub_get("/gists").to_return(json_response("gists.json"))
        gists = @client.gists
        expect(gists.first.user.login).to eq(@username)
      end
    end
  end # .gists

  describe ".starred_gists" do
    it "returns the user's starred gists" do
      stub_get("/gists/starred").to_return(json_response("starred_gists.json"))
      gists = @client.starred_gists
      expect(gists).not_to be_empty
    end
  end

  describe ".gist" do
    it "returns the gist by ID" do
      stub_get("/gists/1").to_return(json_response("gist.json"))
      gist = @client.gist(1)
      expect(gist.user.login).to eq(@username)
    end
  end

  describe ".create_gist" do
    it "creates a new gist" do
      gist_content = JSON.parse(fixture("gist.json").read)
      new_gist = {
        :description => gist_content['description'],
        :public      => gist_content['public'],
        :files       => gist_content['files'],
      }

      stub_post("/gists").with(new_gist).
        to_return(json_response("gist.json"))

      gist = @client.create_gist(new_gist)
      expect(gist).to eq(gist_content)
    end
  end

  describe ".edit_gist" do
    it "edit an existing gist" do
      gist_content = JSON.parse(fixture("gist.json").read)
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
      expect(success).to eq(true)
    end
  end

  describe ".unstar_gist" do
    it "unstars an existing gist" do
      stub_delete("/gists/12345/star").to_return(:status => 204)
      success = @client.unstar_gist(12345)
      expect(success).to eq(true)
    end
  end

  describe ".gist_starred?" do
    it "is starred" do
      stub_get("/gists/12345/star").to_return(:status => 204)
      starred = @client.gist_starred?(12345)
      expect(starred).to eq(true)
    end

    it "is not starred" do
      stub_get("/gists/12345/star").to_return(:status => 404)
      starred = @client.gist_starred?(12345)
      expect(starred).to be_false
    end
  end

  describe ".fork_gist" do
    it "forks an existing gist" do
      stub_post("/gists/12345/forks").
        to_return(json_response("gist.json"))

      gist = @client.fork_gist(12345)
      expect(gist.user.login).to eq(@username)
    end
  end

  describe ".delete_gist" do
    it "deletes an existing gist" do
      stub_delete("/gists/12345").to_return(:status => 204)
      deleted = @client.delete_gist(12345)
      expect(deleted).to eq(true)
    end
  end

  describe ".gist_comments" do
    it "returns the list of gist comments" do
      stub_get("/gists/12345/comments").
        to_return(json_response("gist_comments.json"))
      comments = @client.gist_comments(12345)
      expect(comments.first.id).to eq(451398)
    end
  end

  describe ".gist_comment" do
    it "returns a gist comment" do
      stub_get("/gists/4bcad24/comments/12345").
        to_return(json_response("gist_comment.json"))
      comment = @client.gist_comment("4bcad24", 12345)
      expect(comment.id).to eq(451398)
    end
  end

  describe ".create_gist_comment" do
    it "creates a gist comment" do
      stub_post("/gists/12345/comments").
        to_return(json_response("gist_comment_create.json"))
      comment = @client.create_gist_comment('12345', "This is very helpful.")
      expect(comment.id).to eq(586399)
      expect(comment.body).to eq("This is very helpful.")
    end
  end

  describe ".update_gist_comment" do
    it "updates a gist comment" do
      stub_patch("/gists/4bcad24/comments/12345").
        to_return(json_response("gist_comment_update.json"))
      comment = @client.update_gist_comment("4bcad24", 12345, ":heart:")
      expect(comment.body).to eq(":heart:")
    end
  end

  describe ".delete_gist_comment" do
    it "deletes a gist comment" do
      stub_delete("/gists/4bcad24/comments/12345").to_return(:status => 204)
      result = @client.delete_gist_comment("4bcad24", 12345)
      expect(result).to eq(true)
    end
  end

end

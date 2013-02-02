# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Users do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".search_users" do

    context "with a username passed" do

      it "returns matching username" do
        stub_get("https://api.github.com/legacy/user/search/sferik").
          to_return(json_response("legacy/users.json"))
        users = @client.search_users("sferik")
        expect(users.first.username).to eq("sferik")
      end

    end

  end

  describe ".all_users" do

    it "returns all GitHub users" do
      stub_get("/users").
        to_return(json_response("all_users.json"))
      users = @client.all_users
      expect(users.first.login).to eq("mojombo")
    end

  end

  describe ".user" do

    context "with a username passed" do

      it "returns the user" do
        stub_get("/users/sferik").
          to_return(json_response("user.json"))
        user = @client.user("sferik")
        expect(user.login).to eq("sferik")
      end

    end

    context "without a username passed" do

      it "returns the authenticated user" do
        stub_get("/user").
          to_return(json_response("user.json"))
        user = @client.user
        expect(user.login).to eq("sferik")
      end

    end

  end

  describe '.access_token' do

    context 'with authorization code, client id, and client secret' do

      it 'returns the access_token' do
        stub_post("https://github.com/login/oauth/access_token").
          to_return(json_response("user_token.json"))
        resp = @client.access_token('code', 'id_here', 'secret_here')
        expect(resp.access_token).to eq('this_be_ye_token/use_it_wisely')
      end

    end

  end

  describe ".validate_credentials" do
    it "validates username and password" do
      stub_get("https://sferik:foobar@api.github.com/user").
        to_return(json_response("user.json"))

        expect(Octokit.validate_credentials(:login => 'sferik', :password => 'foobar')).to eq(true)
    end
  end

  describe ".update_user" do

    context "with a location passed" do

      it "updates the user's location" do
        stub_patch("/user").
          with(:body => {:name => "Erik Michaels-Ober", :email => "sferik@gmail.com", :company => "Code for America", :location => "San Francisco", :hireable => false}).
          to_return(json_response("user.json"))
        user = @client.update_user(:name => "Erik Michaels-Ober", :email => "sferik@gmail.com", :company => "Code for America", :location => "San Francisco", :hireable => false)
        expect(user.login).to eq("sferik")
      end

    end

  end

  describe ".followers" do

    context "with a username passed" do

      it "returns the user's followers" do
        stub_get("https://api.github.com/users/sferik/followers").
          to_return(json_response("followers.json"))
        users = @client.followers("sferik")
        expect(users.first.login).to eq("puls")
      end

    end

    context "without a username passed" do

      it "returns the user's followers" do
        stub_get("https://api.github.com/users/sferik/followers").
          to_return(json_response("followers.json"))
        users = @client.followers
        expect(users.first.login).to eq("puls")
      end

    end

  end

  describe ".following" do

    context "with a username passed" do

      it "returns the user's following" do
        stub_get("https://api.github.com/users/sferik/following").
          to_return(json_response("following.json"))
        users = @client.following("sferik")
        expect(users.first.login).to eq("rails")
      end

    end

    context "without a username passed" do

      it "returns the user's following" do
        stub_get("https://api.github.com/users/sferik/following").
          to_return(json_response("following.json"))
        users = @client.following
        expect(users.first.login).to eq("rails")
      end

    end

  end

  describe ".follows?" do

    context "with one user following another" do

      it "returns true" do
        stub_get("https://api.github.com/user/following/puls").
          to_return(:status => 204, :body => "")
        follows = @client.follows?("sferik", "puls")
        expect(follows).to eq(true)
      end

    end

    context "with one user not following another" do

      it "returns false" do
        stub_get("https://api.github.com/user/following/dogbrainz").
          to_return(:status => 404, :body => "")
        follows = @client.follows?("sferik", "dogbrainz")
        expect(follows).to be_false
      end

    end

  end

  describe ".follow" do

    it "follows a user" do
      stub_put("https://api.github.com/user/following/dianakimball").
        to_return(:status => 204, :body => "")
      following = @client.follow("dianakimball")
      expect(following).to eq(true)
    end

  end

  describe ".unfollow" do

    it "unfollows a user" do
      stub_delete("https://api.github.com/user/following/dogbrainz").
        to_return(:status => 204, :body => "")
      following = @client.unfollow("dogbrainz")
      expect(following).to eq(true)
    end

  end

  describe ".starred?" do

    context "with on user starring a repo" do

      it "returns true" do
        stub_get("https://api.github.com/user/starred/sferik/rails_admin").
          to_return(:status => 204, :body => "")
        starred = @client.starred?("sferik", "rails_admin")
        expect(starred).to eq(true)
      end

    end

    context "with on user not starring a repo" do

      it "returns false" do
        stub_get("https://api.github.com/user/starred/sferik/dogbrainz").
          to_return(:status => 404, :body => "")
        starred = @client.starred?("sferik", "dogbrainz")
        expect(starred).to be_false
      end

    end

  end

  describe ".starred" do

    context "with a username passed" do

      it "returns starred repositories" do
        stub_get("https://api.github.com/users/sferik/starred").
          to_return(json_response("starred.json"))
        repositories = @client.starred("sferik")
        expect(repositories.first.name).to eq("grit")
      end

    end

    context "without a username passed" do

      it "returns starred repositories" do
        stub_get("https://api.github.com/users/sferik/starred").
          to_return(json_response("starred.json"))
        repositories = @client.starred
        expect(repositories.first.name).to eq("grit")
      end

    end

  end

  describe ".watched" do

    context "with a username passed" do

      it "returns watched repositories" do
        stub_get("https://api.github.com/users/sferik/watched").
          to_return(json_response("watched.json"))
        repositories = @client.watched("sferik")
        expect(repositories.first.name).to eq("grit")
      end

    end

    context "without a username passed" do

      it "returns watched repositories" do
        stub_get("https://api.github.com/users/sferik/watched").
          to_return(json_response("watched.json"))
        repositories = @client.watched
        expect(repositories.first.name).to eq("grit")
      end

    end

  end

  describe ".key" do

    it "returns a public key" do
      stub_get("https://api.github.com/user/keys/103205").
        to_return(json_response('public_key.json'))
      public_key = @client.key(103205)
      expect(public_key.id).to eq(103205)
      expect(public_key[:key]).to include("ssh-dss AAAAB")
    end

  end

  describe ".keys" do

    it "returns public keys" do
      stub_get("https://api.github.com/user/keys").
        to_return(json_response("public_keys.json"))
      public_keys = @client.keys
      expect(public_keys.first.id).to eq(103205)
    end

  end

  describe ".add_key" do

    it "adds a public key" do
      title, key = "Moss", "ssh-dss AAAAB3NzaC1kc3MAAACBAJz7HanBa18ad1YsdFzHO5Wy1/WgXd4BV+czbKq7q23jungbfjN3eo2a0SVdxux8GG+RZ9ia90VD/X+PE4s3LV60oXZ7PDAuyPO1CTF0TaDoKf9mPaHcPa6agMJVocMsgBgwviWT1Q9VgN1SccDsYVDtxkIAwuw25YeHZlG6myx1AAAAFQCgW+OvXWUdUJPBGkRJ8ML7uf0VHQAAAIAlP5G96tTss0SKYVSCJCyocn9cyGQdNjxah4/aYuYFTbLI1rxk7sr/AkZfJNIoF2UFyO5STbbratykIQGUPdUBg1a2t72bu31x+4ZYJMngNsG/AkZ2oqLiH6dJKHD7PFx2oSPalogwsUV7iSMIZIYaPa03A9763iFsN0qJjaed+gAAAIBxz3Prxdzt/os4XGXSMNoWcS03AFC/05NOkoDMrXxQnTTpp1wrOgyRqEnKz15qC5dWk1ynzK+LJXHDZGA8lXPfCjHpJO3zrlZ/ivvLhgPdDpt13MAhIJFH06hTal0woxbk/fIdY71P3kbgXC0Ppx/0S7BC+VxqRCA4/wcM+BoDbA== host"
      stub_post("https://api.github.com/user/keys").
        with(:title => title, :key => key).
        to_return(json_response("public_key.json"))
      public_key = @client.add_key(title, key)
      expect(public_key.id).to eq(103205)
    end

  end

  describe ".update_key" do

    it "updates a public key" do
      updated_key = {
        :title => "updated title",
        :key => "ssh-rsa BBBB..."
      }
      stub_patch("https://api.github.com/user/keys/1").
        with(updated_key).
          to_return(json_response("public_key_update.json"))
      public_key = @client.update_key(1, updated_key)
      expect(public_key[:title]).to eq(updated_key[:title])
      expect(public_key[:key]).to eq(updated_key[:key])
    end

  end

  describe ".remove_key" do

    it "removes a public key" do
      stub_delete("https://api.github.com/user/keys/103205").
        to_return(:status => 204, :body => "")
      response = @client.remove_key(103205)
      expect(response).to eq(true)
    end

  end

  describe ".emails" do

    it "returns email addresses" do
      stub_get("https://api.github.com/user/emails").
        to_return(json_response("emails.json"))
      emails = @client.emails
      expect(emails.first).to eq("sferik@gmail.com")
    end

  end

  describe ".add_email" do

    it "adds an email address" do
      stub_post("https://api.github.com/user/emails").
        with(:email => "sferik@gmail.com").
        to_return(json_response("emails.json"))
      emails = @client.add_email("sferik@gmail.com")
      expect(emails.first).to eq("sferik@gmail.com")
    end

  end

  describe ".remove_email" do

    it "removes an email address" do
      stub_delete("https://api.github.com/user/emails?email=sferik@gmail.com").
        to_return(:status => 204, :body => "")
      response = @client.remove_email("sferik@gmail.com")
      expect(response).to eq(true)
    end

  end

  describe ".subscriptions" do

    it "returns the repositories the user watches for notifications" do
      stub_get("https://api.github.com/users/pengwynn/subscriptions").
        to_return(json_response("subscriptions.json"))
      subscriptions = @client.subscriptions("pengwynn")
      expect(subscriptions.first.id).to eq(11560)
      expect(subscriptions.first.name).to eq("ujs_sort_helper")
    end
  end

end

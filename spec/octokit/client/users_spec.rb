# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Users do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".search_users" do

    context "with a username passed" do

      it "should return matching username" do
        stub_get("https://api.github.com/legacy/user/search/sferik").
          to_return(:body => fixture("legacy/users.json"))
        users = @client.search_users("sferik")
        users.first.username.should == "sferik"
      end

    end

  end

  describe ".user" do

    context "with a username passed" do

      it "should return the user" do
        stub_get("/users/sferik").
          to_return(:body => fixture("v3/user.json"))
        user = @client.user("sferik")
        user.login.should == "sferik"
      end

    end

    context "without a username passed" do

      it "should return the authenticated user" do
        stub_get("/user").
          to_return(:body => fixture("v3/user.json"))
        user = @client.user
        user.login.should == "sferik"
      end

    end

  end

  describe ".update_user" do

    context "with a location passed" do

      it "should update the user's location" do
        stub_patch("/user").
          with(:body => {:name => "Erik Michaels-Ober", :email => "sferik@gmail.com", :company => "Code for America", :location => "San Francisco", :hireable => false}).
          to_return(:body => fixture("v3/user.json"))
        user = @client.update_user(:name => "Erik Michaels-Ober", :email => "sferik@gmail.com", :company => "Code for America", :location => "San Francisco", :hireable => false)
        user.login.should == "sferik"
      end

    end

  end

  describe ".followers" do

    context "with a username passed" do

      it "should return the user's followers" do
        stub_get("https://api.github.com/users/sferik/followers").
          to_return(:body => fixture("v3/followers.json"))
        users = @client.followers("sferik")
        users.first.login.should == "puls"
      end

    end

    context "without a username passed" do

      it "should return the user's followers" do
        stub_get("https://api.github.com/users/sferik/followers").
          to_return(:body => fixture("v3/followers.json"))
        users = @client.followers
        users.first.login.should == "puls"
      end

    end

  end

  describe ".following" do

    context "with a username passed" do

      it "should return the user's following" do
        stub_get("https://api.github.com/users/sferik/following").
          to_return(:body => fixture("v3/following.json"))
        users = @client.following("sferik")
        users.first.login.should == "rails"
      end

    end

    context "without a username passed" do

      it "should return the user's following" do
        stub_get("https://api.github.com/users/sferik/following").
          to_return(:body => fixture("v3/following.json"))
        users = @client.following
        users.first.login.should == "rails"
      end

    end

  end

  describe ".follows?" do

    context "with one user following another" do

      it "should return true" do
        stub_get("https://api.github.com/user/following/puls").
          to_return(:status => 204, :body => "")
        follows = @client.follows?("sferik", "puls")
        follows.should be_true
      end

    end

    context "with one user not following another" do

      it "should return false" do
        stub_get("https://api.github.com/user/following/dogbrainz").
          to_return(:status => 404, :body => "")
        follows = @client.follows?("sferik", "dogbrainz")
        follows.should be_false
      end

    end

  end

  describe ".follow" do

    it "should follow a user" do
      stub_put("https://api.github.com/user/following/dianakimball").
        to_return(:status => 204, :body => "")
      following = @client.follow("dianakimball")
      following.should be_true
    end

  end

  describe ".unfollow" do

    it "should unfollow a user" do
      stub_delete("https://api.github.com/user/following/dogbrainz").
        to_return(:status => 204, :body => "")
      following = @client.unfollow("dogbrainz")
      following.should be_true
    end

  end

  describe ".starred?" do

    context "with on user starring a repo" do

      it "should return true" do
        stub_get("https://api.github.com/user/starred/sferik/rails_admin").
          to_return(:status => 204, :body => "")
        starred = @client.starred?("sferik", "rails_admin")
        starred.should be_true
      end

    end

    context "with on user not starring a repo" do

      it "should return false" do
        stub_get("https://api.github.com/user/starred/sferik/dogbrainz").
          to_return(:status => 404, :body => "")
        starred = @client.starred?("sferik", "dogbrainz")
        starred.should be_false
      end

    end

  end

  describe ".starred" do

    context "with a username passed" do

      it "should return starred repositories" do
        stub_get("https://api.github.com/users/sferik/starred").
          to_return(:body => fixture("v3/starred.json"))
        repositories = @client.starred("sferik")
        repositories.first.name.should == "grit"
      end

    end

    context "without a username passed" do

      it "should return starred repositories" do
        stub_get("https://api.github.com/users/sferik/starred").
          to_return(:body => fixture("v3/starred.json"))
        repositories = @client.starred
        repositories.first.name.should == "grit"
      end

    end

  end

  describe ".watched" do

    context "with a username passed" do

      it "should return watched repositories" do
        stub_get("https://api.github.com/users/sferik/watched").
          to_return(:body => fixture("v3/watched.json"))
        repositories = @client.watched("sferik")
        repositories.first.name.should == "grit"
      end

    end

    context "without a username passed" do

      it "should return watched repositories" do
        stub_get("https://api.github.com/users/sferik/watched").
          to_return(:body => fixture("v3/watched.json"))
        repositories = @client.watched
        repositories.first.name.should == "grit"
      end

    end

  end

  describe ".keys" do

    it "should return public keys" do
      stub_get("https://api.github.com/user/keys").
        to_return(:body => fixture("v3/public_keys.json"))
      public_keys = @client.keys
      public_keys.first.id.should == 103205
    end

  end

  describe ".add_key" do

    it "should add a public key" do
      title, key = "Moss", "ssh-dss AAAAB3NzaC1kc3MAAACBAJz7HanBa18ad1YsdFzHO5Wy1/WgXd4BV+czbKq7q23jungbfjN3eo2a0SVdxux8GG+RZ9ia90VD/X+PE4s3LV60oXZ7PDAuyPO1CTF0TaDoKf9mPaHcPa6agMJVocMsgBgwviWT1Q9VgN1SccDsYVDtxkIAwuw25YeHZlG6myx1AAAAFQCgW+OvXWUdUJPBGkRJ8ML7uf0VHQAAAIAlP5G96tTss0SKYVSCJCyocn9cyGQdNjxah4/aYuYFTbLI1rxk7sr/AkZfJNIoF2UFyO5STbbratykIQGUPdUBg1a2t72bu31x+4ZYJMngNsG/AkZ2oqLiH6dJKHD7PFx2oSPalogwsUV7iSMIZIYaPa03A9763iFsN0qJjaed+gAAAIBxz3Prxdzt/os4XGXSMNoWcS03AFC/05NOkoDMrXxQnTTpp1wrOgyRqEnKz15qC5dWk1ynzK+LJXHDZGA8lXPfCjHpJO3zrlZ/ivvLhgPdDpt13MAhIJFH06hTal0woxbk/fIdY71P3kbgXC0Ppx/0S7BC+VxqRCA4/wcM+BoDbA== host"
      stub_post("https://api.github.com/user/keys").
        with(:title => title, :key => key).
        to_return(:status => 201, :body => fixture("v3/public_key.json"))
      public_key = @client.add_key(title, key)
      public_key.id.should == 103205
    end

  end

  describe ".remove_key" do

    it "should remove a public key" do
      stub_delete("https://api.github.com/user/keys/103205").
        to_return(:status => 204, :body => "")
      response = @client.remove_key(103205)
      response.should be_true
    end

  end

  describe ".emails" do

    it "should return email addresses" do
      stub_get("https://api.github.com/user/emails").
        to_return(:body => fixture("v3/emails.json"))
      emails = @client.emails
      emails.first.should == "sferik@gmail.com"
    end

  end

  describe ".add_email" do

    it "should add an email address" do
      stub_post("https://api.github.com/user/emails").
        with(:email => "sferik@gmail.com").
        to_return(:body => fixture("v3/emails.json"))
      emails = @client.add_email("sferik@gmail.com")
      emails.first.should == "sferik@gmail.com"
    end

  end

  describe ".remove_email" do

    it "should remove an email address" do
      stub_delete("https://api.github.com/user/emails?email=sferik@gmail.com").
        to_return(:status => 204, :body => "")
      response = @client.remove_email("sferik@gmail.com")
      response.should be_true
    end

  end

end

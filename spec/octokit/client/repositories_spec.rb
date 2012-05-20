# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Repositories do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".search_user" do

    it "should return matching repositories" do
      stub_get("https://api.github.com/legacy/repos/search/One40Proof").
        to_return(:body => fixture("v2/repositories.json"))
      repositories = @client.search_repositories("One40Proof")
      repositories.first.name.should == "One40Proof"
    end

  end

  describe ".repository" do

    it "should return the matching repository" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      repository = @client.repository("sferik/rails_admin")
      repository.name.should == "rails_admin"
    end

  end

  describe ".update_repository" do

    it "should update the matching repository" do
      description = "RailsAdmin is a Rails 3 engine that provides an easy-to-use interface for managing your data"
      stub_patch("/repos/sferik/rails_admin").
        with(:body => {:description => description}).
        to_return(:body => fixture("v3/repository.json"))
      repository = @client.edit_repository("sferik/rails_admin", :description => description)
      repository.description.should == description
    end

  end

  describe ".repositories" do

    context "with a username passed" do

      it "should return user's repositories" do
        stub_get("/users/sferik/repos").
          to_return(:body => fixture("v3/repositories.json"))
        repositories = @client.repositories("sferik")
        repositories.first.name.should == "merb-admin"
      end

    end

    context "without a username passed" do

      it "should return authenticated user's repositories" do
        stub_get("/user/repos").
          to_return(:body => fixture("v3/repositories.json"))
        repositories = @client.repositories
        repositories.first.name.should == "merb-admin"
      end

    end

  end

  describe ".watch" do

    it "should watch a repository" do
      stub_put("/user/watched/sferik/rails_admin").
        to_return(:status => 204)
      @client.watch("sferik/rails_admin").should be_nil
    end

  end

  describe ".unwatch" do

    it "should unwatch a repository" do
      stub_delete("/user/watched/sferik/rails_admin").
        to_return(:status => 204)
      @client.unwatch("sferik/rails_admin").should be_nil
    end

  end

  describe ".fork" do

    it "should fork a repository" do
      stub_post("/repos/sferik/rails_admin/forks").
        to_return(:body => fixture("v3/repository.json"))
      repository = @client.fork("sferik/rails_admin")
      repository.name.should == "rails_admin"
    end

  end

  describe ".create_repository" do

    it "should create a repository" do
      stub_post("/user/repos").
        with(:name => "rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      repository = @client.create_repository("rails_admin")
      repository.name.should == "rails_admin"
    end

    it "should create a repository for an organization" do
      stub_post("/orgs/comorichwebgroup/repos").
        with(:name => "demo").
        to_return(:body => fixture("v3/organization-repository.json"))
      repository = @client.create_repository("demo", {:organization => 'comorichwebgroup'})
      repository.name.should == "demo"
      repository.organization.login.should == "CoMoRichWebGroup"
    end

  end

  describe ".set_private" do

    it "should set a repository private" do
      stub_patch("/repos/sferik/rails_admin").
        with({ :name => "rails_admin", :private => false }).
        to_return(:body => fixture("v3/repository.json"))
      repository = @client.set_private("sferik/rails_admin")
      repository.name.should == "rails_admin"
    end

  end

  describe ".set_public" do

    it "should set a repository public" do
      stub_patch("/repos/sferik/rails_admin").
        with({ :name => "rails_admin", :private => true }).
        to_return(:body => fixture("v3/repository.json"))
      repository = @client.set_public("sferik/rails_admin")
      repository.name.should == "rails_admin"
      repository.private.should == false
    end

  end

  describe ".deploy_keys" do

    it "should return a repository's deploy keys" do
      stub_get("/repos/sferik/rails_admin/keys").
        to_return(:body => fixture("v3/public_keys.json"))
      public_keys = @client.deploy_keys("sferik/rails_admin")
      public_keys.first.id.should == 103205
    end

  end

  describe ".add_deploy_key" do

    it "should add a repository deploy keys" do
      stub_post("/repos/sferik/rails_admin/keys").
        with(:body => { :title => "Moss", :key => "ssh-dss AAAAB3NzaC1kc3MAAACBAJz7HanBa18ad1YsdFzHO5Wy1/WgXd4BV+czbKq7q23jungbfjN3eo2a0SVdxux8GG+RZ9ia90VD/X+PE4s3LV60oXZ7PDAuyPO1CTF0TaDoKf9mPaHcPa6agMJVocMsgBgwviWT1Q9VgN1SccDsYVDtxkIAwuw25YeHZlG6myx1AAAAFQCgW+OvXWUdUJPBGkRJ8ML7uf0VHQAAAIAlP5G96tTss0SKYVSCJCyocn9cyGQdNjxah4/aYuYFTbLI1rxk7sr/AkZfJNIoF2UFyO5STbbratykIQGUPdUBg1a2t72bu31x+4ZYJMngNsG/AkZ2oqLiH6dJKHD7PFx2oSPalogwsUV7iSMIZIYaPa03A9763iFsN0qJjaed+gAAAIBxz3Prxdzt/os4XGXSMNoWcS03AFC/05NOkoDMrXxQnTTpp1wrOgyRqEnKz15qC5dWk1ynzK+LJXHDZGA8lXPfCjHpJO3zrlZ/ivvLhgPdDpt13MAhIJFH06hTal0woxbk/fIdY71P3kbgXC0Ppx/0S7BC+VxqRCA4/wcM+BoDbA== host" }).
        to_return(:body => fixture("v3/public_key.json"))
      public_key = @client.add_deploy_key("sferik/rails_admin", "Moss", "ssh-dss AAAAB3NzaC1kc3MAAACBAJz7HanBa18ad1YsdFzHO5Wy1/WgXd4BV+czbKq7q23jungbfjN3eo2a0SVdxux8GG+RZ9ia90VD/X+PE4s3LV60oXZ7PDAuyPO1CTF0TaDoKf9mPaHcPa6agMJVocMsgBgwviWT1Q9VgN1SccDsYVDtxkIAwuw25YeHZlG6myx1AAAAFQCgW+OvXWUdUJPBGkRJ8ML7uf0VHQAAAIAlP5G96tTss0SKYVSCJCyocn9cyGQdNjxah4/aYuYFTbLI1rxk7sr/AkZfJNIoF2UFyO5STbbratykIQGUPdUBg1a2t72bu31x+4ZYJMngNsG/AkZ2oqLiH6dJKHD7PFx2oSPalogwsUV7iSMIZIYaPa03A9763iFsN0qJjaed+gAAAIBxz3Prxdzt/os4XGXSMNoWcS03AFC/05NOkoDMrXxQnTTpp1wrOgyRqEnKz15qC5dWk1ynzK+LJXHDZGA8lXPfCjHpJO3zrlZ/ivvLhgPdDpt13MAhIJFH06hTal0woxbk/fIdY71P3kbgXC0Ppx/0S7BC+VxqRCA4/wcM+BoDbA== host")
      public_key.id.should == 103205
    end

  end

  describe ".remove_deploy_key" do

    it "should remove a repository deploy keys" do
      stub_delete("/repos/sferik/rails_admin/keys/#{103205}").
        to_return(:status => 204)
      result = @client.remove_deploy_key("sferik/rails_admin", 103205)
      result.should be_nil
    end

  end

  describe ".collaborators" do

    it "should return a repository's collaborators" do
      stub_get("/repos/sferik/rails_admin/collaborators").
        to_return(:body => fixture("v3/collaborators.json"))
      collaborators = @client.collaborators("sferik/rails_admin")
      collaborators.first.login.should == "sferik"
    end

  end

  describe ".add_collaborator" do

    it "should add a repository collaborators" do
      stub_put("/repos/sferik/rails_admin/collaborators/sferik").
        to_return(:status => 204)
      result = @client.add_collaborator("sferik/rails_admin", "sferik")
      result.should be_nil
    end

  end

  describe ".remove_collaborator" do

    it "should remove a repository collaborators" do
      stub_delete("/repos/sferik/rails_admin/collaborators/sferik").
        to_return(:status => 204)
      result = @client.remove_collaborator("sferik/rails_admin", "sferik")
      result.should be_nil
    end

  end

  describe ".pushable" do

    it "should return all pushable repositories" do
      stub_get("https://github.com/api/v2/json/repos/pushable").
        to_return(:body => fixture("v2/repositories.json"))
      repositories = @client.pushable
      repositories.first.name.should == "One40Proof"
    end

  end

  describe ".repository_teams" do

    it "should return all repository teams" do
      stub_get("/repos/codeforamerica/open311/teams").
        to_return(:body => fixture("v3/teams.json"))
      teams = @client.repository_teams("codeforamerica/open311")
      teams.first.name.should == "Fellows"
    end

  end

  describe ".contributors" do

    context "with anonymous users" do

      it "should return all repository contributors" do
        stub_get("/repos/sferik/rails_admin/contributors?anon=true").
          to_return(:body => fixture("v3/contributors.json"))
        contributors = @client.contributors("sferik/rails_admin", true)
        contributors.first.login.should == "sferik"
      end

    end

    context "without anonymous users" do

      it "should return all repository contributors" do
        stub_get("/repos/sferik/rails_admin/contributors?anon=false").
          to_return(:body => fixture("v3/contributors.json"))
        contributors = @client.contributors("sferik/rails_admin")
        contributors.first.login.should == "sferik"
      end

    end

  end

  describe ".watchers" do

    it "should return all repository watchers" do
      stub_get("/repos/sferik/rails_admin/watchers").
        to_return(:body => fixture("v3/watchers.json"))
      watchers = @client.watchers("sferik/rails_admin")
      watchers.first.login.should == "sferik"
    end

  end

  describe ".network" do

    it "should return a repository's network" do
      stub_get("/repos/sferik/rails_admin/forks").
        to_return(:body => fixture("v3/forks.json"))
      network = @client.network("sferik/rails_admin")
      network.first.owner.login.should == "digx"
    end

  end

  describe ".languages" do

    it "should return a repository's languages" do
      stub_get("/repos/sferik/rails_admin/languages").
        to_return(:body => fixture("v3/languages.json"))
      languages = @client.languages("sferik/rails_admin")
      languages["Ruby"].should == 345701
    end

  end

  describe ".tags" do

    it "should return a repository's tags" do
      stub_get("/repos/pengwynn/octokit/tags").
        to_return(:body => fixture("v3/tags.json"))
      tags = @client.tags("pengwynn/octokit")
      v0_6_4 = tags.find { |tag| tag.name == "v0.6.4" }
      v0_6_4.commit.sha.should == "09bcc30e7286eeb1bbde68d0ace7a6b90b1a84a2"
    end

  end

  describe ".branches" do

    it "should return a repository's branches" do
      stub_get("/repos/pengwynn/octokit/branches").
        to_return(:body => fixture("v3/branches.json"))
      branches = @client.branches("pengwynn/octokit")
      master = branches.find { |branch| branch.name == "master" }
      master.commit.sha.should == "88553a397f7293b3ba176dc27cd1ab6bb93d5d14"
    end

  end

  describe ".hooks" do

    it "should return a repository's hooks" do
      stub_get("/repos/railsbp/railsbp.com/hooks").
        to_return(:body => fixture("v3/hooks.json"))
      hooks = @client.hooks("railsbp/railsbp.com")
      hook = hooks.find { |hook| hook.name == "railsbp" }
      hook.config.token.should == "xAAQZtJhYHGagsed1kYR"
    end

  end

  describe ".hook" do

    it "should return a repository's single hook" do
      stub_get("/repos/railsbp/railsbp.com/hooks/154284").
        to_return(:body => fixture("v3/hook.json"))
      hook = @client.hook("railsbp/railsbp.com", 154284)
      hook.config.token.should == "xAAQZtJhYHGagsed1kYR"
    end

  end

  describe ".create_hook" do

    it "should create a hook" do
      stub_post("/repos/railsbp/railsbp.com/hooks").
        with(:body => {:name => "railsbp", :config => {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"}, :events => ["push"], :active => true}).
        to_return(:body => fixture("v3/hook.json"))
      hook = @client.create_hook("railsbp/railsbp.com", "railsbp", {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"})
      hook.id.should == 154284
    end

  end

  describe ".edit_hook" do

    it "should edit a hook" do
      stub_patch("/repos/railsbp/railsbp.com/hooks/154284").
        with(:body => {:name => "railsbp", :config => {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"}, :events => ["push"], :active => true}).
        to_return(:body => fixture("v3/hook.json"))
      hook = @client.edit_hook("railsbp/railsbp.com", 154284, "railsbp", {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"})
      hook.id.should == 154284
      hook.config.token.should == "xAAQZtJhYHGagsed1kYR"
    end

  end

  describe ".remove_hook" do

    it "should remove a hook" do
      stub_delete("/repos/railsbp/railsbp.com/hooks/154284").
        to_return(:status => 204)
      @client.remove_hook("railsbp/railsbp.com", 154284).should be_nil
    end

  end

  describe ".test_hook" do

    it "should test a hook" do
      stub_post("/repos/railsbp/railsbp.com/hooks/154284/test").
        to_return(:status => 204)
      @client.test_hook("railsbp/railsbp.com", 154284).should be_nil
    end

  end

  describe ".events" do

    it "should list event for all issues in a repository" do
      stub_get("/repos/pengwynn/octokit/issues/events").
      to_return(:body => fixture("v3/repo_issues_events.json"))
      events = @client.repo_issue_events("pengwynn/octokit")
      events.first.actor.login.should == "ctshryock"
      events.first.event.should == "subscribed"
    end

  end

end

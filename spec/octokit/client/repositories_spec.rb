# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Repositories do

  before do
    stub_get("https://api.github.com/").
      to_return(:body => fixture("v3/root.json"))
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".search_user" do

    it "returns matching repositories" do
      stub_get("https://api.github.com/legacy/repos/search/One40Proof").
        to_return(:body => fixture("legacy/repositories.json"))
      repositories = @client.search_repositories("One40Proof")
      expect(repositories.first.name).to eq("One40Proof")
    end

  end

  describe ".repository" do

    it "returns the matching repository" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      repository = @client.repository("sferik/rails_admin")
      expect(repository.name).to eq("rails_admin")
    end

  end

  describe ".update_repository" do

    it "updates the matching repository" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      description = "RailsAdmin is a Rails 3 engine that provides an easy-to-use interface for managing your data"
      stub_patch("/repos/sferik/rails_admin").
        with(:body => {:description => description}).
        to_return(:body => fixture("v3/repository.json"))
      repository = @client.edit_repository("sferik/rails_admin", :description => description)
      expect(repository.description).to eq(description)
    end

  end

  describe ".repositories" do

    context "with a username passed" do

      it "returns user's repositories" do
        stub_get("/users/sferik").
          to_return(:body => fixture("v3/user.json"))
        stub_get("/users/sferik/repos").
          to_return(:body => fixture("v3/repositories.json"))
        repositories = @client.repositories("sferik")
        expect(repositories.first.name).to eq("merb-admin")
      end

    end

    context "without a username passed" do

      it "returns authenticated user's repositories" do
        stub_get("/user").
          to_return(:body => fixture("v3/user.json"))
        stub_get("/users/sferik/repos").
          to_return(:body => fixture("v3/repositories.json"))
        repositories = @client.repositories
        expect(repositories.first.name).to eq("merb-admin")
      end

    end

  end

  describe ".star" do

    it "stars a repository" do
      stub_get("/user").
        to_return(:body => fixture("v3/user.json"))
      stub_put("/user/starred/sferik/rails_admin").
        to_return(:status => 204)
      expect(@client.star("sferik/rails_admin")).to be_true
    end

  end

  describe ".unstar" do

    it "unstars a repository" do
      stub_get("/user").
        to_return(:body => fixture("v3/user.json"))
      stub_delete("/user/starred/sferik/rails_admin").
        to_return(:status => 204)
      expect(@client.unstar("sferik/rails_admin")).to be_true
    end

  end

  describe ".fork" do

    it "forks a repository" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_post("/repos/sferik/rails_admin/forks").
        to_return(:body => fixture("v3/repository.json"))
      repository = @client.fork("sferik/rails_admin")
      expect(repository.name).to eq("rails_admin")
    end

  end

  describe ".create_repository" do

    it "creates a repository" do
      stub_post("/user/repos").
        with(:name => "rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      repository = @client.create_repository("rails_admin")
      expect(repository.name).to eq("rails_admin")
    end

    it "creates a repository for an organization" do
      stub_get("/orgs/codeforamerica").
        to_return(:body => fixture("v3/organization.json"))
      stub_post("/orgs/codeforamerica/repos").
        with(:name => "demo").
        to_return(:body => fixture("v3/organization-repository.json"))
      repository = @client.create_repository("demo", {:organization => 'codeforamerica'})
      expect(repository.name).to eq("demo")
      expect(repository.organization.login).to eq("codeforamerica")
    end

  end

  describe ".delete_repository" do

    it "deletes a repository" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_delete("/repos/sferik/rails_admin").
        to_return(:status => 204, :body => "")
      result = @client.delete_repository("sferik/rails_admin")
      expect(result).to be_true
    end

  end

  describe ".set_private" do

    it "sets a repository private" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_patch("/repos/sferik/rails_admin").
        with({ :name => "rails_admin", :private => false }).
        to_return(:body => fixture("v3/repository.json"))
      repository = @client.set_private("sferik/rails_admin")
      expect(repository.name).to eq("rails_admin")
    end

  end

  describe ".set_public" do

    it "sets a repository public" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_patch("/repos/sferik/rails_admin").
        with({ :name => "rails_admin", :private => true }).
        to_return(:body => fixture("v3/repository.json"))
      repository = @client.set_public("sferik/rails_admin")
      expect(repository.name).to eq("rails_admin")
      expect(repository.private).to eq(false)
    end

  end

  describe ".deploy_keys" do

    it "returns a repository's deploy keys" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_get("/repos/sferik/rails_admin/keys").
        to_return(:body => fixture("v3/public_keys.json"))
      public_keys = @client.deploy_keys("sferik/rails_admin")
      expect(public_keys.first.id).to eq(103205)
    end

  end

  describe ".add_deploy_key" do

    it "adds a repository deploy keys" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_post("/repos/sferik/rails_admin/keys").
        with(:body => { :title => "Moss", :key => "ssh-dss AAAAB3NzaC1kc3MAAACBAJz7HanBa18ad1YsdFzHO5Wy1/WgXd4BV+czbKq7q23jungbfjN3eo2a0SVdxux8GG+RZ9ia90VD/X+PE4s3LV60oXZ7PDAuyPO1CTF0TaDoKf9mPaHcPa6agMJVocMsgBgwviWT1Q9VgN1SccDsYVDtxkIAwuw25YeHZlG6myx1AAAAFQCgW+OvXWUdUJPBGkRJ8ML7uf0VHQAAAIAlP5G96tTss0SKYVSCJCyocn9cyGQdNjxah4/aYuYFTbLI1rxk7sr/AkZfJNIoF2UFyO5STbbratykIQGUPdUBg1a2t72bu31x+4ZYJMngNsG/AkZ2oqLiH6dJKHD7PFx2oSPalogwsUV7iSMIZIYaPa03A9763iFsN0qJjaed+gAAAIBxz3Prxdzt/os4XGXSMNoWcS03AFC/05NOkoDMrXxQnTTpp1wrOgyRqEnKz15qC5dWk1ynzK+LJXHDZGA8lXPfCjHpJO3zrlZ/ivvLhgPdDpt13MAhIJFH06hTal0woxbk/fIdY71P3kbgXC0Ppx/0S7BC+VxqRCA4/wcM+BoDbA== host" }).
        to_return(:body => fixture("v3/public_key.json"))
      public_key = @client.add_deploy_key("sferik/rails_admin", "Moss", "ssh-dss AAAAB3NzaC1kc3MAAACBAJz7HanBa18ad1YsdFzHO5Wy1/WgXd4BV+czbKq7q23jungbfjN3eo2a0SVdxux8GG+RZ9ia90VD/X+PE4s3LV60oXZ7PDAuyPO1CTF0TaDoKf9mPaHcPa6agMJVocMsgBgwviWT1Q9VgN1SccDsYVDtxkIAwuw25YeHZlG6myx1AAAAFQCgW+OvXWUdUJPBGkRJ8ML7uf0VHQAAAIAlP5G96tTss0SKYVSCJCyocn9cyGQdNjxah4/aYuYFTbLI1rxk7sr/AkZfJNIoF2UFyO5STbbratykIQGUPdUBg1a2t72bu31x+4ZYJMngNsG/AkZ2oqLiH6dJKHD7PFx2oSPalogwsUV7iSMIZIYaPa03A9763iFsN0qJjaed+gAAAIBxz3Prxdzt/os4XGXSMNoWcS03AFC/05NOkoDMrXxQnTTpp1wrOgyRqEnKz15qC5dWk1ynzK+LJXHDZGA8lXPfCjHpJO3zrlZ/ivvLhgPdDpt13MAhIJFH06hTal0woxbk/fIdY71P3kbgXC0Ppx/0S7BC+VxqRCA4/wcM+BoDbA== host")
      expect(public_key.id).to eq(103205)
    end

  end

  describe ".remove_deploy_key" do

    it "removes a repository deploy keys" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_delete("/repos/sferik/rails_admin/keys/#{103205}").
        to_return(:status => 204)
      result = @client.remove_deploy_key("sferik/rails_admin", 103205)
      expect(result).to be_true
    end

  end

  describe ".collaborators" do

    it "returns a repository's collaborators" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_get("/repos/sferik/rails_admin/collaborators").
        to_return(:body => fixture("v3/collaborators.json"))
      collaborators = @client.collaborators("sferik/rails_admin")
      expect(collaborators.first.login).to eq("sferik")
    end

  end

  describe ".add_collaborator" do

    it "adds a repository collaborators" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_put("/repos/sferik/rails_admin/collaborators/sferik").
        to_return(:status => 204)
      result = @client.add_collaborator("sferik/rails_admin", "sferik")
      expect(result).to be_true
    end

  end

  describe ".remove_collaborator" do

    it "removes a repository collaborators" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_delete("/repos/sferik/rails_admin/collaborators/sferik").
        to_return(:status => 204)
      result = @client.remove_collaborator("sferik/rails_admin", "sferik")
      expect(result).to be_true
    end

  end

  describe ".repository_teams" do

    it "returns all repository teams" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_get("/repos/sferik/rails_admin/teams").
        to_return(:body => fixture("v3/teams.json"))
      teams = @client.repository_teams("sferik/rails_admin")
      expect(teams.first.name).to eq("Fellows")
    end

  end

  describe ".contributors" do

    context "with anonymous users" do

      it "returns all repository contributors" do
        stub_get("/repos/sferik/rails_admin").
          to_return(:body => fixture("v3/repository.json"))
        stub_get("/repos/sferik/rails_admin/contributors?anon=true").
          to_return(:body => fixture("v3/contributors.json"))
        contributors = @client.contributors("sferik/rails_admin", true)
        expect(contributors.first.login).to eq("sferik")
      end

    end

    context "without anonymous users" do

      it "returns all repository contributors" do
        stub_get("/repos/sferik/rails_admin").
          to_return(:body => fixture("v3/repository.json"))
        stub_get("/repos/sferik/rails_admin/contributors?anon=false").
          to_return(:body => fixture("v3/contributors.json"))
        contributors = @client.contributors("sferik/rails_admin")
        expect(contributors.first.login).to eq("sferik")
      end

    end

  end

  describe ".stargazers" do

    it "returns all repository stargazers" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_get("/repos/sferik/rails_admin/stargazers").
        to_return(:body => fixture("v3/stargazers.json"))
      stargazers = @client.stargazers("sferik/rails_admin")
      expect(stargazers.first.login).to eq("sferik")
    end

  end

  describe ".network" do

    it "returns a repository's network" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_get("/repos/sferik/rails_admin/forks").
        to_return(:body => fixture("v3/forks.json"))
      network = @client.network("sferik/rails_admin")
      expect(network.first.owner.login).to eq("digx")
    end

  end

  describe ".languages" do

    it "returns a repository's languages" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_get("/repos/sferik/rails_admin/languages").
        to_return(:body => fixture("v3/languages.json"))
      languages = @client.languages("sferik/rails_admin")
      expect(languages.Ruby).to eq(345701)
    end

  end

  describe ".tags" do

    it "returns a repository's tags" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_get("/repos/sferik/rails_admin/tags").
        to_return(:body => fixture("v3/tags.json"))
      tags = @client.tags("sferik/rails_admin")
      v0_6_4 = tags.find { |tag| tag.name == "v0.6.4" }
      expect(v0_6_4.commit.sha).to eq("09bcc30e7286eeb1bbde68d0ace7a6b90b1a84a2")
    end

  end

  describe ".branches" do

    it "returns a repository's branches" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_get("/repos/sferik/rails_admin/branches").
        to_return(:body => fixture("v3/branches.json"))
      branches = @client.branches("sferik/rails_admin")
      master = branches.find { |branch| branch.name == "master" }
      expect(master.commit.sha).to eq("88553a397f7293b3ba176dc27cd1ab6bb93d5d14")
    end

    it "returns a single branch" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_get("/repos/sferik/rails_admin/branches/master").
        to_return(:body => fixture("v3/branch.json"))
      result = @client.branch("sferik/rails_admin", "master")
      expect(result.commit.sha).to eq("24046beeade2115311c8dfc625720b68e2bf89aa")
    end

  end

  describe ".hooks" do

    it "returns a repository's hooks" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_get("/repos/sferik/rails_admin/hooks").
        to_return(:body => fixture("v3/hooks.json"))
      hooks = @client.hooks("sferik/rails_admin")
      hook = hooks.find { |hook| hook.name == "railsbp" }
      expect(hook.config.token).to eq("xAAQZtJhYHGagsed1kYR")
    end

  end

  describe ".hook" do

    it "returns a repository's single hook" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_get("/repos/sferik/rails_admin/hooks/154284").
        to_return(:body => fixture("v3/hook.json"))
      hook = @client.hook("sferik/rails_admin", 154284)
      expect(hook.config.token).to eq("xAAQZtJhYHGagsed1kYR")
    end

  end

  describe ".create_hook" do

    it "creates a hook" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_post("/repos/sferik/rails_admin/hooks").
        with(:body => {:name => "railsbp", :config => {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"}, :events => ["push"], :active => true}).
        to_return(:body => fixture("v3/hook.json"))
      hook = @client.create_hook("sferik/rails_admin", "railsbp", {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"})
      expect(hook.id).to eq(154284)
    end

  end

  describe ".edit_hook" do

    it "edits a hook" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_patch("/repos/sferik/rails_admin/hooks/154284").
        with(:body => {:name => "railsbp", :config => {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"}, :events => ["push"], :active => true}).
        to_return(:body => fixture("v3/hook.json"))
      hook = @client.edit_hook("sferik/rails_admin", 154284, "railsbp", {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"})
      expect(hook.id).to eq(154284)
      expect(hook.config.token).to eq("xAAQZtJhYHGagsed1kYR")
    end

  end

  describe ".remove_hook" do

    it "removes a hook" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_delete("/repos/sferik/rails_admin/hooks/154284").
        to_return(:status => 204)
      expect(@client.remove_hook("sferik/rails_admin", 154284)).to be_nil
    end

  end

  describe ".test_hook" do

    it "tests a hook" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_get("/repos/sferik/rails_admin/hooks/154284").
        to_return(:body => fixture("v3/hook.json"))
      stub_post("/repos/sferik/rails_admin/hooks/154284/test").
        to_return(:status => 204)
      expect(@client.test_hook("sferik/rails_admin", 154284)).to be_nil
    end

  end

  describe ".events" do

    it "lists events for all issues in a repository" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_get("/repos/sferik/rails_admin/issues/events").
      to_return(:body => fixture("v3/repo_issues_events.json"))
      events = @client.repo_issue_events("sferik/rails_admin")
      expect(events.first.actor.login).to eq("ctshryock")
      expect(events.first.event).to eq("subscribed")
    end

  end

  describe ".assignees" do

    it "lists all the available assignees (owner + collaborators)" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_get("/repos/sferik/rails_admin/assignees").
      to_return(:body => fixture("v3/repo_assignees.json"))
      assignees = @client.repo_assignees("sferik/rails_admin")
      expect(assignees.first.login).to eq("adamstac")
    end

  end

  describe ".subscribers" do

    it "lists all the users watching the repository" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_get("/repos/sferik/rails_admin/subscribers").
        to_return(:body => fixture("v3/subscribers.json"))
      subscribers = @client.subscribers("sferik/rails_admin")
      expect(subscribers.first.id).to eq(865)
      expect(subscribers.first.login).to eq("pengwynn")
    end

  end

  describe ".subscription" do

    it "returns a repository subscription" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_get("/repos/sferik/rails_admin/subscription").
        to_return(:body => fixture("v3/subscription.json"))
      subscription = @client.subscription("sferik/rails_admin")
      expect(subscription.subscribed).to be_true
    end

  end

  describe ".update_subscription" do

    it "updates a repository subscription" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_put("/repos/sferik/rails_admin/subscription").
        to_return(:body => fixture("v3/subscription_update.json"))
      subscription = @client.update_subscription("sferik/rails_admin", :subscribed => false)
      expect(subscription.subscribed).to be_false
    end

  end

  describe ".delete_subscription" do

    it "returns true when repo subscription deleted" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_delete("/repos/sferik/rails_admin/subscription").
        to_return(:status => 204)
      result = @client.delete_subscription("sferik/rails_admin")
      expect(result).to be_true
    end

    it "returns false when delete repo subscription fails" do
      stub_get("/repos/sferik/rails_admin").
        to_return(:body => fixture("v3/repository.json"))
      stub_delete("/repos/sferik/rails_admin/subscription").
        to_return(:status => 500)
      result = @client.delete_subscription("sferik/rails_admin")
      expect(result).to be_false
    end

  end

end

# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Repositories do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".search_user" do

    it "returns matching repositories" do
      stub_get("https://api.github.com/legacy/repos/search/One40Proof").
        to_return(json_response("legacy/repositories.json"))
      repositories = @client.search_repositories("One40Proof")
      expect(repositories.first.name).to eq("One40Proof")
    end

  end

  describe ".repository" do

    it "returns the matching repository" do
      stub_get("/repos/sferik/rails_admin").
        to_return(json_response("repository.json"))
      repository = @client.repository("sferik/rails_admin")
      expect(repository.name).to eq("rails_admin")
    end

  end

  describe ".update_repository" do

    it "updates the matching repository" do
      description = "RailsAdmin is a Rails 3 engine that provides an easy-to-use interface for managing your data"
      stub_patch("/repos/sferik/rails_admin").
        with(:body => {:description => description}).
        to_return(json_response("repository.json"))
      repository = @client.edit_repository("sferik/rails_admin", :description => description)
      expect(repository.description).to eq(description)
    end

  end

  describe ".repositories" do

    context "with a username passed" do

      it "returns user's repositories" do
        stub_get("/users/sferik/repos").
          to_return(json_response("repositories.json"))
        repositories = @client.repositories("sferik")
        expect(repositories.first.name).to eq("merb-admin")
      end

    end

    context "without a username passed" do

      it "returns authenticated user's repositories" do
        stub_get("/user/repos").
          to_return(json_response("repositories.json"))
        repositories = @client.repositories
        expect(repositories.first.name).to eq("merb-admin")
      end

    end

  end

  describe ".all_repositories" do

    it "returns all repositories on github" do
      stub_get("/repositories").
        to_return(json_response("all_repositories.json"))
      repositories = @client.all_repositories
      expect(repositories.first.name).to eq("grit")
    end

  end

  describe ".star" do

    it "stars a repository" do
      stub_put("/user/starred/sferik/rails_admin").
        to_return(:status => 204)
      expect(@client.star("sferik/rails_admin")).to eq(true)
    end

  end

  describe ".unstar" do

    it "unstars a repository" do
      stub_delete("/user/starred/sferik/rails_admin").
        to_return(:status => 204)
      expect(@client.unstar("sferik/rails_admin")).to eq(true)
    end

  end

  describe ".watch" do

    it "watches a repository" do
      stub_put("/user/watched/sferik/rails_admin").
        to_return(:status => 204)
      expect(@client.watch("sferik/rails_admin")).to eq(true)
    end

  end

  describe ".unwatch" do

    it "unwatches a repository" do
      stub_delete("/user/watched/sferik/rails_admin").
        to_return(:status => 204)
      expect(@client.unwatch("sferik/rails_admin")).to eq(true)
    end

  end

  describe ".fork" do

    it "forks a repository" do
      stub_post("/repos/sferik/rails_admin/forks").
        to_return(json_response("repository.json"))
      repository = @client.fork("sferik/rails_admin")
      expect(repository.name).to eq("rails_admin")
    end

  end

  describe ".create_repository" do

    it "creates a repository" do
      stub_post("/user/repos").
        with(:name => "rails_admin").
        to_return(json_response("repository.json"))
      repository = @client.create_repository("rails_admin")
      expect(repository.name).to eq("rails_admin")
    end

    it "creates a repository for an organization" do
      stub_post("/orgs/comorichwebgroup/repos").
        with(:name => "demo").
        to_return(json_response("organization-repository.json"))
      repository = @client.create_repository("demo", {:organization => 'comorichwebgroup'})
      expect(repository.name).to eq("demo")
      expect(repository.organization.login).to eq("CoMoRichWebGroup")
    end

  end

  describe ".delete_repository" do

    it "deletes a repository" do
      stub_delete("/repos/sferik/rails_admin").
        to_return(:status => 204, :body => "")
      result = @client.delete_repository("sferik/rails_admin")
      expect(result).to eq(true)
    end

  end

  describe ".set_private" do

    it "sets a repository private" do
      stub_patch("/repos/sferik/rails_admin").
        with({ :name => "rails_admin", :private => false }).
        to_return(json_response("repository.json"))
      repository = @client.set_private("sferik/rails_admin")
      expect(repository.name).to eq("rails_admin")
    end

  end

  describe ".set_public" do

    it "sets a repository public" do
      stub_patch("/repos/sferik/rails_admin").
        with({ :name => "rails_admin", :private => true }).
        to_return(json_response("repository.json"))
      repository = @client.set_public("sferik/rails_admin")
      expect(repository.name).to eq("rails_admin")
      expect(repository.private).to eq(false)
    end

  end

  describe ".deploy_keys" do

    it "returns a repository's deploy keys" do
      stub_get("/repos/sferik/rails_admin/keys").
        to_return(json_response("public_keys.json"))
      public_keys = @client.deploy_keys("sferik/rails_admin")
      expect(public_keys.first.id).to eq(103205)
    end

  end

  describe ".add_deploy_key" do

    it "adds a repository deploy keys" do
      stub_post("/repos/sferik/rails_admin/keys").
        with(:body => { :title => "Moss", :key => "ssh-dss AAAAB3NzaC1kc3MAAACBAJz7HanBa18ad1YsdFzHO5Wy1/WgXd4BV+czbKq7q23jungbfjN3eo2a0SVdxux8GG+RZ9ia90VD/X+PE4s3LV60oXZ7PDAuyPO1CTF0TaDoKf9mPaHcPa6agMJVocMsgBgwviWT1Q9VgN1SccDsYVDtxkIAwuw25YeHZlG6myx1AAAAFQCgW+OvXWUdUJPBGkRJ8ML7uf0VHQAAAIAlP5G96tTss0SKYVSCJCyocn9cyGQdNjxah4/aYuYFTbLI1rxk7sr/AkZfJNIoF2UFyO5STbbratykIQGUPdUBg1a2t72bu31x+4ZYJMngNsG/AkZ2oqLiH6dJKHD7PFx2oSPalogwsUV7iSMIZIYaPa03A9763iFsN0qJjaed+gAAAIBxz3Prxdzt/os4XGXSMNoWcS03AFC/05NOkoDMrXxQnTTpp1wrOgyRqEnKz15qC5dWk1ynzK+LJXHDZGA8lXPfCjHpJO3zrlZ/ivvLhgPdDpt13MAhIJFH06hTal0woxbk/fIdY71P3kbgXC0Ppx/0S7BC+VxqRCA4/wcM+BoDbA== host" }).
        to_return(json_response("public_key.json"))
      public_key = @client.add_deploy_key("sferik/rails_admin", "Moss", "ssh-dss AAAAB3NzaC1kc3MAAACBAJz7HanBa18ad1YsdFzHO5Wy1/WgXd4BV+czbKq7q23jungbfjN3eo2a0SVdxux8GG+RZ9ia90VD/X+PE4s3LV60oXZ7PDAuyPO1CTF0TaDoKf9mPaHcPa6agMJVocMsgBgwviWT1Q9VgN1SccDsYVDtxkIAwuw25YeHZlG6myx1AAAAFQCgW+OvXWUdUJPBGkRJ8ML7uf0VHQAAAIAlP5G96tTss0SKYVSCJCyocn9cyGQdNjxah4/aYuYFTbLI1rxk7sr/AkZfJNIoF2UFyO5STbbratykIQGUPdUBg1a2t72bu31x+4ZYJMngNsG/AkZ2oqLiH6dJKHD7PFx2oSPalogwsUV7iSMIZIYaPa03A9763iFsN0qJjaed+gAAAIBxz3Prxdzt/os4XGXSMNoWcS03AFC/05NOkoDMrXxQnTTpp1wrOgyRqEnKz15qC5dWk1ynzK+LJXHDZGA8lXPfCjHpJO3zrlZ/ivvLhgPdDpt13MAhIJFH06hTal0woxbk/fIdY71P3kbgXC0Ppx/0S7BC+VxqRCA4/wcM+BoDbA== host")
      expect(public_key.id).to eq(103205)
    end

  end

  describe ".remove_deploy_key" do

    it "removes a repository deploy keys" do
      stub_delete("/repos/sferik/rails_admin/keys/#{103205}").
        to_return(:status => 204)
      result = @client.remove_deploy_key("sferik/rails_admin", 103205)
      expect(result).to eq(true)
    end

  end

  describe ".collaborators" do

    it "returns a repository's collaborators" do
      stub_get("/repos/sferik/rails_admin/collaborators").
        to_return(json_response("collaborators.json"))
      collaborators = @client.collaborators("sferik/rails_admin")
      expect(collaborators.first.login).to eq("sferik")
    end

  end

  describe ".add_collaborator" do

    it "adds a repository collaborators" do
      stub_put("/repos/sferik/rails_admin/collaborators/sferik").
        to_return(:status => 204)
      result = @client.add_collaborator("sferik/rails_admin", "sferik")
      expect(result).to eq(true)
    end

  end

  describe ".remove_collaborator" do

    it "removes a repository collaborators" do
      stub_delete("/repos/sferik/rails_admin/collaborators/sferik").
        to_return(:status => 204)
      result = @client.remove_collaborator("sferik/rails_admin", "sferik")
      expect(result).to eq(true)
    end

  end

  describe ".repository_teams" do

    it "returns all repository teams" do
      stub_get("/repos/codeforamerica/open311/teams").
        to_return(json_response("teams.json"))
      teams = @client.repository_teams("codeforamerica/open311")
      expect(teams.first.name).to eq("Fellows")
    end

  end

  describe ".contributors" do

    context "with anonymous users" do

      it "returns all repository contributors" do
        stub_get("/repos/sferik/rails_admin/contributors?anon=true").
          to_return(json_response("contributors.json"))
        contributors = @client.contributors("sferik/rails_admin", true)
        expect(contributors.first.login).to eq("sferik")
      end

    end

    context "without anonymous users" do

      it "returns all repository contributors" do
        stub_get("/repos/sferik/rails_admin/contributors?anon=false").
          to_return(json_response("contributors.json"))
        contributors = @client.contributors("sferik/rails_admin")
        expect(contributors.first.login).to eq("sferik")
      end

    end

  end

  describe ".stargazers" do

    it "returns all repository stargazers" do
      stub_get("/repos/sferik/rails_admin/stargazers").
        to_return(json_response("stargazers.json"))
      stargazers = @client.stargazers("sferik/rails_admin")
      expect(stargazers.first.login).to eq("sferik")
    end

  end

  describe ".watchers" do

    it "returns all repository watchers" do
      stub_get("/repos/sferik/rails_admin/watchers").
        to_return(json_response("watchers.json"))
      watchers = @client.watchers("sferik/rails_admin")
      expect(watchers.first.login).to eq("sferik")
    end

  end

  describe ".network" do

    it "returns a repository's network" do
      stub_get("/repos/sferik/rails_admin/forks").
        to_return(json_response("forks.json"))
      network = @client.network("sferik/rails_admin")
      expect(network.first.owner.login).to eq("digx")
    end

  end

  describe ".languages" do

    it "returns a repository's languages" do
      stub_get("/repos/sferik/rails_admin/languages").
        to_return(json_response("languages.json"))
      languages = @client.languages("sferik/rails_admin")
      expect(languages["Ruby"]).to eq(345701)
    end

  end

  describe ".tags" do

    it "returns a repository's tags" do
      stub_get("/repos/pengwynn/octokit/tags").
        to_return(json_response("tags.json"))
      tags = @client.tags("pengwynn/octokit")
      v0_6_4 = tags.find { |tag| tag.name == "v0.6.4" }
      expect(v0_6_4.commit.sha).to eq("09bcc30e7286eeb1bbde68d0ace7a6b90b1a84a2")
    end

  end

  describe ".branches" do

    it "returns a repository's branches" do
      stub_get("/repos/pengwynn/octokit/branches").
        to_return(json_response("branches.json"))
      branches = @client.branches("pengwynn/octokit")
      master = branches.find { |branch| branch.name == "master" }
      expect(master.commit.sha).to eq("88553a397f7293b3ba176dc27cd1ab6bb93d5d14")
    end

    it "returns a single branch" do
      branch = JSON.parse(fixture("branches.json").read).last
      stub_get("/repos/pengwynn/octokit/branches/master").
        to_return(:body => branch)
      branch = @client.branch("pengwynn/octokit", "master")
      expect(branch.commit.sha).to eq("88553a397f7293b3ba176dc27cd1ab6bb93d5d14")
    end

  end

  describe ".hooks" do

    it "returns a repository's hooks" do
      stub_get("/repos/railsbp/railsbp.com/hooks").
        to_return(json_response("hooks.json"))
      hooks = @client.hooks("railsbp/railsbp.com")
      hook = hooks.find { |hook| hook.name == "railsbp" }
      expect(hook.config.token).to eq("xAAQZtJhYHGagsed1kYR")
    end

  end

  describe ".hook" do

    it "returns a repository's single hook" do
      stub_get("/repos/railsbp/railsbp.com/hooks/154284").
        to_return(json_response("hook.json"))
      hook = @client.hook("railsbp/railsbp.com", 154284)
      expect(hook.config.token).to eq("xAAQZtJhYHGagsed1kYR")
    end

  end

  describe ".create_hook" do

    it "creates a hook" do
      stub_post("/repos/railsbp/railsbp.com/hooks").
        with(:body => {:name => "railsbp", :config => {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"}, :events => ["push"], :active => true}).
        to_return(json_response("hook.json"))
      hook = @client.create_hook("railsbp/railsbp.com", "railsbp", {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"})
      expect(hook.id).to eq(154284)
    end

  end

  describe ".edit_hook" do

    it "edits a hook" do
      stub_patch("/repos/railsbp/railsbp.com/hooks/154284").
        with(:body => {:name => "railsbp", :config => {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"}, :events => ["push"], :active => true}).
        to_return(json_response("hook.json"))
      hook = @client.edit_hook("railsbp/railsbp.com", 154284, "railsbp", {:railsbp_url => "http://railsbp.com", :token => "xAAQZtJhYHGagsed1kYR"})
      expect(hook.id).to eq(154284)
      expect(hook.config.token).to eq("xAAQZtJhYHGagsed1kYR")
    end

  end

  describe ".remove_hook" do

    it "removes a hook" do
      stub_delete("/repos/railsbp/railsbp.com/hooks/154284").
        to_return(:status => 204)
      expect(@client.remove_hook("railsbp/railsbp.com", 154284)).to eq(true)
    end

  end

  describe ".test_hook" do

    it "tests a hook" do
      stub_post("/repos/railsbp/railsbp.com/hooks/154284/tests").
        to_return(:status => 204)
      expect(@client.test_hook("railsbp/railsbp.com", 154284)).to eq(true)
    end

  end

  describe ".events" do

    it "lists events for all issues in a repository" do
      stub_get("/repos/pengwynn/octokit/issues/events").
      to_return(json_response("repo_issues_events.json"))
      events = @client.repo_issue_events("pengwynn/octokit")
      expect(events.first.actor.login).to eq("ctshryock")
      expect(events.first.event).to eq("subscribed")
    end

  end

  describe ".assignees" do

    it "lists all the available assignees (owner + collaborators)" do
      stub_get("/repos/pengwynn/octokit/assignees").
      to_return(json_response("repo_assignees.json"))
      assignees = @client.repo_assignees("pengwynn/octokit")
      expect(assignees.first.login).to eq("adamstac")
    end

  end

  describe ".subscribers" do

    it "lists all the users watching the repository" do
      stub_get("/repos/pengwynn/octokit/subscribers").
        to_return(json_response("subscribers.json"))
      subscribers = @client.subscribers("pengwynn/octokit")
      expect(subscribers.first.id).to eq(865)
      expect(subscribers.first.login).to eq("pengwynn")
    end

  end

  describe ".subscription" do

    it "returns a repository subscription" do
      stub_get("/repos/pengwynn/octokit/subscription").
        to_return(json_response("subscription.json"))
      subscription = @client.subscription("pengwynn/octokit")
      expect(subscription.subscribed).to eq(true)
    end

  end

  describe ".update_subscription" do

    it "updates a repository subscription" do
      stub_put("/repos/pengwynn/octokit/subscription").
        to_return(json_response("subscription_update.json"))
      subscription = @client.update_subscription("pengwynn/octokit", :subscribed => false)
      expect(subscription.subscribed).to be_false
    end

  end

  describe ".delete_subscription" do

    it "returns true when repo subscription deleted" do
      stub_delete("/repos/pengwynn/octokit/subscription").
        to_return(:status => 204)
      result = @client.delete_subscription("pengwynn/octokit")
      expect(result).to eq(true)
    end

    it "returns false when delete repo subscription fails" do
      stub_delete("/repos/pengwynn/octokit/subscription").
        to_return(:status => 404)
      result = @client.delete_subscription("pengwynn/octokit")
      expect(result).to be_false
    end

  end

end

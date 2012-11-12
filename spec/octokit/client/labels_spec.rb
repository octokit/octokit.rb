# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Labels do

  before do
    stub_get("https://api.github.com/").
      to_return(:body => fixture("v3/root.json"))
    stub_get("/repos/sferik/rails_admin").
      to_return(:body => fixture("v3/repository.json"))
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".labels" do

    it "returns labels" do
      stub_get("/repos/sferik/rails_admin/labels").
        to_return(:body => fixture("v3/labels.json"))
      labels = @client.labels("sferik/rails_admin")
      expect(labels.first.name).to eq("V3 Transition")
    end

  end

  describe ".label" do

    it "returns a single labels" do
      stub_get("/repos/sferik/rails_admin/labels/V3+Addition").
        to_return(:status => 200, :body => fixture('v3/label.json'))
      label = @client.label("sferik/rails_admin", "V3 Addition")
      expect(label.name).to eq("V3 Addition")
    end

  end

  describe ".add_label" do

    it "adds a label with a color" do
      stub_post("/repos/sferik/rails_admin/labels").
        with(:body => {"name" => "a significant bug", "color" => "ededed"},
             :headers => {'Content-Type'=>'application/json'}).
        to_return(:status => 201, :body => fixture('v3/label.json'))
      labels = @client.add_label("sferik/rails_admin", "a significant bug", 'ededed')
      expect(labels.color).to eq("ededed")
      expect(labels.name).to  eq("V3 Addition")
    end

    it "adds a label with default color" do
      stub_post("/repos/sferik/rails_admin/labels").
        with(:body => {"name" => "another significant bug", "color" => "ffffff"},
             :headers => {'Content-Type'=>'application/json'}).
        to_return(:status => 201, :body => fixture('v3/label.json'))
      labels = @client.add_label("sferik/rails_admin", "another significant bug")
      expect(labels.color).to eq("ededed")
      expect(labels.name).to  eq("V3 Addition")
    end

  end

  describe ".update_label" do

    it "updates a label with a new color" do
      stub_put("/repos/sferik/rails_admin/labels/V3+Addition").
        with(:body => {"color" => "ededed"},
            :headers => {'Content-Type'=>'application/json'}).
        to_return(:status => 200, :body => fixture('v3/label.json'))

      label = @client.update_label("sferik/rails_admin", "V3 Addition", {:color => 'ededed'})
      expect(label.color).to eq('ededed')
    end

  end

  describe ".delete_label!" do

    it "deletes a label from the repository" do
      stub_delete("/repos/sferik/rails_admin/labels/V3+Transition").
       to_return(:status => 204)

      result = @client.delete_label!("sferik/rails_admin", "V3 Transition")
      expect(result).to be_true
    end

  end

  describe ".remove_label" do

    it "removes a label from the specified issue" do
      stub_get("/repos/sferik/rails_admin/issues/12").
        to_return(:body => fixture("v3/issue.json"))
      stub_delete("/repos/sferik/rails_admin/issues/12/labels/V3+Transition").
        to_return(:status => 200, :body => fixture('v3/labels.json'), :headers => {})

      response = @client.remove_label("sferik/rails_admin", 12, "V3 Transition")
      expect(response.last.name).to eq('Bug')
    end

  end

  describe ".remove_all_labels" do

    it "removes all labels from the specified issue" do
      stub_get("/repos/sferik/rails_admin/issues/12").
        to_return(:body => fixture("v3/issue.json"))
      stub_delete("/repos/sferik/rails_admin/issues/12/labels").
        to_return(:status => 204)

      result = @client.remove_all_labels('sferik/rails_admin', 12)
      expect(result).to be_true
    end

  end

  describe ".add_labels_to_an_issue" do
    it "adds labels to a given issue" do
      stub_get("/repos/sferik/rails_admin/issues/12").
        to_return(:body => fixture("v3/issue.json"))
      stub_post("/repos/sferik/rails_admin/issues/12/labels").
        with(:body => '["V3 Transition","Bug"]',
            :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json'}).
        to_return(:status => 200, :body => fixture('v3/labels.json'), :headers => {})

      labels = @client.add_labels_to_an_issue('sferik/rails_admin', 12, ['V3 Transition', 'Bug'])
      expect(labels.first.name).to eq('V3 Transition')
      expect(labels.last.name).to  eq('Bug')
    end
  end

  describe ".replace_all_labels" do
    it "replaces all labels for an issue" do
      stub_get("/repos/sferik/rails_admin/issues/12").
        to_return(:body => fixture("v3/issue.json"))

      stub_put("/repos/sferik/rails_admin/issues/12/labels").
        with(:body => '["V3 Transition","V3 Adding"]',
            :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json'}).
        to_return(:status => 200, :body => fixture('v3/labels.json'), :headers => {})

      labels = @client.replace_all_labels('sferik/rails_admin', 12, ['V3 Transition', 'V3 Adding'])
      expect(labels.first.name).to eq('V3 Transition')
    end
  end

  describe ".labels_for_milestone" do
    it "returns all labels for a repository" do
      stub_get('/repos/sferik/rails_admin/milestones/12/labels').
        to_return(:status => 200, :body => fixture('v3/labels.json'), :headers => {})

      labels = @client.labels_for_milestone('sferik/rails_admin', 12)
      expect(labels.size).to eq(3)
    end
  end

  describe ".labels_for_issue" do
    it "returns all labels for a given issue" do
      stub_get("/repos/sferik/rails_admin/issues/12").
        to_return(:body => fixture("v3/issue.json"))
      stub_get("/repos/sferik/rails_admin/issues/12/labels").
        to_return(:status => 200, :body => fixture('v3/labels.json'), :headers => {})

      labels = @client.labels_for_issue('sferik/rails_admin', 12)
      expect(labels.first.name).to eq('V3 Transition')
      expect(labels.last.name).to  eq('Bug')
    end
  end

end

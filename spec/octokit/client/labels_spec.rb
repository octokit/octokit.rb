# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Labels do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".labels" do

    it "returns labels" do
      stub_get("/repos/pengwynn/octokit/labels").
        to_return(json_response("labels.json"))
      labels = @client.labels("pengwynn/octokit")
      expect(labels.first.name).to eq("V3 Transition")
    end

  end

  describe ".label" do

    it "returns a single labels" do
      stub_get("/repos/pengwynn/octokit/labels/V3+Addition").
        to_return(json_response('label.json'))
      label = @client.label("pengwynn/octokit", "V3 Addition")
      expect(label.name).to eq("V3 Addition")
    end

  end

  describe ".add_label" do

    it "adds a label with a color" do
      stub_post("/repos/pengwynn/octokit/labels").
        with(:body => {"name" => "a significant bug", "color" => "ededed"}).
        to_return(json_response('label.json'))
      labels = @client.add_label("pengwynn/octokit", "a significant bug", 'ededed')
      expect(labels.color).to eq("ededed")
      expect(labels.name).to  eq("V3 Addition")
    end

    it "adds a label with default color" do
      stub_post("/repos/pengwynn/octokit/labels").
        with(:body => {"name" => "another significant bug", "color" => "ffffff"}).
        to_return(json_response('label.json'))
      labels = @client.add_label("pengwynn/octokit", "another significant bug")
      expect(labels.color).to eq("ededed")
      expect(labels.name).to  eq("V3 Addition")
    end

  end

  describe ".update_label" do

    it "updates a label with a new color" do
      stub_post("/repos/pengwynn/octokit/labels/V3+Addition").
        with(:body => {"color" => "ededed"},
            :headers => {'Content-Type'=>'application/json'}).
        to_return(json_response('label.json'))

      label = @client.update_label("pengwynn/octokit", "V3 Addition", {:color => 'ededed'})
      expect(label.color).to eq('ededed')
    end

  end

  describe ".delete_label!" do

    it "deletes a label from the repository" do
      stub_delete("/repos/pengwynn/octokit/labels/V3+Transition").
       to_return(:status => 204)

      result = @client.delete_label!("pengwynn/octokit", "V3 Transition")
      expect(result).to eq(true)
    end

  end

  describe ".remove_label" do

    it "removes a label from the specified issue" do
      stub_delete("/repos/pengwynn/octokit/issues/23/labels/V3+Transition").
        to_return(json_response('labels.json'), :headers => {})

      response = @client.remove_label("pengwynn/octokit", 23, "V3 Transition")
      expect(response.last.name).to eq('Bug')
    end

  end

  describe ".remove_all_labels" do

    it "removes all labels from the specified issue" do
     stub_delete("/repos/pengwynn/octokit/issues/23/labels").
       to_return(:status => 204)

     result = @client.remove_all_labels('pengwynn/octokit', 23)
     expect(result).to eq(true)
    end

  end

  describe ".add_labels_to_an_issue" do
    it "adds labels to a given issue" do
      stub_post("/repos/pengwynn/octokit/issues/42/labels").
        with(:body => '["V3 Transition","Bug"]').
        to_return(json_response('labels.json'), :headers => {})

      labels = @client.add_labels_to_an_issue('pengwynn/octokit', 42, ['V3 Transition', 'Bug'])
      expect(labels.first.name).to eq('V3 Transition')
      expect(labels.last.name).to  eq('Bug')
    end
  end

  describe ".replace_all_labels" do
    it "replaces all labels for an issue" do
       stub_put("/repos/pengwynn/octokit/issues/42/labels").
         with(:body => '["V3 Transition","V3 Adding"]').
         to_return(json_response('labels.json'), :headers => {})

      labels = @client.replace_all_labels('pengwynn/octokit', 42, ['V3 Transition', 'V3 Adding'])
      expect(labels.first.name).to eq('V3 Transition')
    end
  end

  describe ".lables_for_milestone" do
    it "returns all labels for a repository" do
      stub_get('/repos/pengwynn/octokit/milestones/2/labels').
        to_return(json_response('labels.json'), :headers => {})

      labels = @client.labels_for_milestone('pengwynn/octokit', 2)
      expect(labels.size).to eq(3)
    end
  end

  describe ".labels_for_issue" do
    it "returns all labels for a given issue" do
      stub_get("/repos/pengwynn/octokit/issues/37/labels").
        to_return(json_response('labels.json'), :headers => {})

      labels = @client.labels_for_issue('pengwynn/octokit', 37)
      expect(labels.first.name).to eq('V3 Transition')
      expect(labels.last.name).to  eq('Bug')
    end
  end

end

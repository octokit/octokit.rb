# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Issues do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".labels" do

    it "should return labels" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/labels").
        to_return(:body => fixture("v3/labels.json"))
      labels = @client.labels("pengwynn/octokit")
      labels.first.name.should == "V3 Transition"
    end

  end

  describe ".label" do

    it "should return a single labels" do
      stub_get("https://api.github.com/repos/pengwynn/octokit/labels/V3+Addition").
        to_return(:status => 200, :body => fixture('v3/label.json'))
      label = @client.label("pengwynn/octokit", "V3 Addition")
      label.name.should == "V3 Addition"
    end

  end

  describe ".add_label" do

    it "should add a label with a color" do
      stub_post("https://api.github.com/repos/pengwynn/octokit/labels").
        with(:body => "{\"name\":\"a significant bug\",\"color\":\"ededed\"}", 
             :headers => {'Content-Type'=>'application/json'}).
        to_return(:status => 201, :body => fixture('v3/label.json'))
      labels = @client.add_label("pengwynn/octokit", "a significant bug", 'ededed')
      labels.color.should == "ededed"
      labels.name.should  == "V3 Addition"
    end

    it "should add a label with default color" do
      stub_post("https://api.github.com/repos/pengwynn/octokit/labels").
        with(:body => "{\"name\":\"another significant bug\",\"color\":\"ffffff\"}", 
             :headers => {'Content-Type'=>'application/json'}).
        to_return(:status => 201, :body => fixture('v3/label.json'))
      labels = @client.add_label("pengwynn/octokit", "another significant bug")
      labels.color.should == "ededed"
      labels.name.should  == "V3 Addition"
    end

  end

  describe ".update_label" do

    it "should update a label with a new color" do
      stub_post("https://api.github.com/repos/pengwynn/octokit/labels/V3+Addition").
        with(:body => "{\"color\":\"ededed\"}", 
            :headers => {'Content-Type'=>'application/json'}).
        to_return(:status => 200, :body => fixture('v3/label.json'))
    
      label = @client.update_label("pengwynn/octokit", "V3 Addition", {:color => 'ededed'})
      label.color.should == 'ededed'
    end

  end

  describe ".delete_label!" do

    it "should delete a label from the repository" do
      stub_delete("https://api.github.com/repos/pengwynn/octokit/labels/V3+Transition").
       to_return(:status => 204)
      
      response = @client.delete_label!("pengwynn/octokit", "V3 Transition")
      response.status.should == 204
    end

  end

  describe ".remove_label" do

    it "should remove a label from the specified issue" do
      stub_delete("https://api.github.com/repos/pengwynn/octokit/issues/23/labels/V3+Transition").
        to_return(:status => 200, :body => fixture('v3/labels.json'), :headers => {})
      
      response = @client.remove_label("pengwynn/octokit", 23, "V3 Transition")
      response.last.name.should == 'Bug'
    end

  end

  describe ".remove_all_labels" do

    it "should remove all labels from the specified issue" do
     stub_delete("https://api.github.com/repos/pengwynn/octokit/issues/23/labels").
       to_return(:status => 204)

     response = @client.remove_all_labels('pengwynn/octokit', 23)
     response.status.should == 204
    end

  end

  describe ".add_labels_to_an_issue" do
    it "should add labels to a given issue" do
      stub_post("https://api.github.com/repos/pengwynn/octokit/issues/42/labels").
        with(:body => "[\"V3 Transition\",\"Bug\"]", 
            :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => fixture('v3/labels.json'), :headers => {})
    
      labels = @client.add_labels_to_an_issue('pengwynn/octokit', 42, ['V3 Transition', 'Bug'])
      labels.first.name.should == 'V3 Transition'
      labels.last.name.should  == 'Bug'
    end
  end

  describe ".replace_all_labels" do
    it "should replace all labels for an issue" do
       stub_put("https://api.github.com/repos/pengwynn/octokit/issues/42/labels").
         with(:body => "[\"V3 Transition\",\"V3 Adding\"]", 
              :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => fixture('v3/labels.json'), :headers => {})

      labels = @client.replace_all_labels('pengwynn/octokit', 42, ['V3 Transition', 'V3 Adding'])
      labels.first.name.should == 'V3 Transition'
    end
  end

  describe ".lables_for_milestone" do
    it "should return all labels for a repository" do
      stub_get('https://api.github.com/repos/pengwynn/octokit/milestones/2/labels').
        to_return(:status => 200, :body => fixture('v3/labels.json'), :headers => {})

      labels = @client.labels_for_milestone('pengwynn/octokit', 2)
      labels.size.should == 3
    end
  end

end

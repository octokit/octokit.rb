require 'helper'

describe Octokit::Client::Issues do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".search_issues" do

    it "should return matching issues" do
      stub_get("issues/search/sferik/rails_admin/open/activerecord").
        to_return(:body => fixture("issues.json"))
      issues = @client.search_issues("sferik/rails_admin", "activerecord")
      issues.first.number.should == 105
    end

  end

  describe ".issues" do

    it "should return issues" do
      stub_get("issues/list/sferik/rails_admin/open").
        to_return(:body => fixture("issues.json"))
      issues = @client.issues("sferik/rails_admin")
      issues.first.number.should == 105
    end

  end

  describe ".issues_labeled" do

    it "should return issues with a particular label" do
      stub_get("issues/list/sferik/rails_admin/label/bug").
        to_return(:body => fixture("issues.json"))
      issues = @client.issues_labeled("sferik/rails_admin", "bug")
      issues.first.number.should == 105
    end

  end

  describe ".issue" do

    it "should return an issue" do
      stub_get("issues/show/sferik/rails_admin/105").
        to_return(:body => fixture("issue.json"))
      issue = @client.issue("sferik/rails_admin", 105)
      issue.number.should == 105
    end

  end

  describe ".issue_comments" do

    it "should return comments for an issue" do
      stub_get("issues/comments/sferik/rails_admin/105").
        to_return(:body => fixture("comments.json"))
      comments = @client.issue_comments("sferik/rails_admin", 105)
      comments.first.user.should == "jackdempsey"
    end

  end

  describe ".create_issue" do

    it "should create an issue" do
      stub_post("issues/open/sferik/rails_admin").
        with(:body => {:title => "Use OrmAdapter instead of talking directly to ActiveRecord", :body => "Hi,\n\nI just tried to play with this in an app with no ActiveRecord.  I was disappointed.  It seems the only reason the engine relies on AR is to provide History functionality.  I would argue that having the History in a database, and therefore tying the app to AR & SQL, isn't worth it.  How about we change it to just dump to a CSV and remove the AR dep?\n\n$0.02"}).
        to_return(:body => fixture("issue.json"))
      issue = @client.create_issue("sferik/rails_admin", "Use OrmAdapter instead of talking directly to ActiveRecord", "Hi,\n\nI just tried to play with this in an app with no ActiveRecord.  I was disappointed.  It seems the only reason the engine relies on AR is to provide History functionality.  I would argue that having the History in a database, and therefore tying the app to AR & SQL, isn't worth it.  How about we change it to just dump to a CSV and remove the AR dep?\n\n$0.02")
      issue.number.should == 105
    end

  end

  describe ".close_issue" do

    it "should close an issue" do
      stub_post("issues/close/sferik/rails_admin/105").
        to_return(:body => fixture("issue.json"))
      issue = @client.close_issue("sferik/rails_admin", 105)
      issue.number.should == 105
    end

  end

  describe ".reopen_issue" do

    it "should reopen an issue" do
      stub_post("issues/reopen/sferik/rails_admin/105").
        to_return(:body => fixture("issue.json"))
      issue = @client.reopen_issue("sferik/rails_admin", 105)
      issue.number.should == 105
    end

  end

  describe ".update_issue" do

    it "should update an issue" do
      stub_post("issues/edit/sferik/rails_admin/105").
        with(:body => {:title => "Use OrmAdapter instead of talking directly to ActiveRecord", :body => "Hi,\n\nI just tried to play with this in an app with no ActiveRecord.  I was disappointed.  It seems the only reason the engine relies on AR is to provide History functionality.  I would argue that having the History in a database, and therefore tying the app to AR & SQL, isn't worth it.  How about we change it to just dump to a CSV and remove the AR dep?\n\n$0.02"}).
        to_return(:body => fixture("issue.json"))
      issue = @client.update_issue("sferik/rails_admin", 105, "Use OrmAdapter instead of talking directly to ActiveRecord", "Hi,\n\nI just tried to play with this in an app with no ActiveRecord.  I was disappointed.  It seems the only reason the engine relies on AR is to provide History functionality.  I would argue that having the History in a database, and therefore tying the app to AR & SQL, isn't worth it.  How about we change it to just dump to a CSV and remove the AR dep?\n\n$0.02")
      issue.number.should == 105
    end

  end

  describe ".labels" do

    it "should return labels" do
      stub_get("issues/labels/sferik/rails_admin").
        to_return(:body => fixture("labels.json"))
      labels = @client.labels("sferik/rails_admin")
      labels.first.should == "bug"
    end

  end

  describe ".add_label" do

    it "should add a label" do
      stub_post("issues/label/add/sferik/rails_admin/bug").
        to_return(:body => fixture("labels.json"))
      labels = @client.add_label("sferik/rails_admin", "bug")
      labels.first.should == "bug"
    end

  end

  describe ".remove_label" do

    it "should remove a label" do
      stub_post("issues/label/remove/sferik/rails_admin/bug").
        to_return(:body => fixture("labels.json"))
      labels = @client.remove_label("sferik/rails_admin", "bug")
      labels.first.should == "bug"
    end

  end

  describe ".add_comment" do

    it "should add a comment" do
      stub_post("issues/comment/sferik/rails_admin/105").
        with(:comment => "I don't think I'd like it in a CSV for a variety of reasons, but I do agree that it doesn't have to be AR. I would imagine if there was a patch and work done towards allowing a pluggable History model, it'd be at least considered. I don't have the time at the moment to do this, but I'd imagine you could start with abstracting out the calls to read/write History, ultimately allowing for a drop in of any storage structure. \r\n\r\nIn fact, it might be interesting to leverage wycats moneta towards this end: http://github.com/wycats/moneta").
        to_return(:body => fixture("comment.json"))
      comment = @client.add_comment("sferik/rails_admin", 105, "I don't think I'd like it in a CSV for a variety of reasons, but I do agree that it doesn't have to be AR. I would imagine if there was a patch and work done towards allowing a pluggable History model, it'd be at least considered. I don't have the time at the moment to do this, but I'd imagine you could start with abstracting out the calls to read/write History, ultimately allowing for a drop in of any storage structure. \r\n\r\nIn fact, it might be interesting to leverage wycats moneta towards this end: http://github.com/wycats/moneta")
      comment.user.should == "jackdempsey"
    end

  end

end

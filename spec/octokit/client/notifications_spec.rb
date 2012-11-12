# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Notifications do

  before do
    stub_get("https://api.github.com/").
      to_return(:body => fixture("v3/root.json"))
    stub_get("/repos/sferik/rails_admin").
      to_return(:body => fixture("v3/repository.json"))
    @client = Octokit::Client.new(:login => "joeyw")
  end

  describe ".notifications" do

    it "lists the notifications for the current user" do
      stub_get("https://api.github.com/notifications").
        to_return(:body => fixture("v3/notifications.json"))
      notifications = @client.notifications
      expect(notifications.first.id).to eq(1)
      expect(notifications.first.unread).to be_true
    end

  end

  describe ".repository_notifications" do

    it "lists all notifications for a repository" do
      stub_get("https://api.github.com/repos/sferik/rails_admin/notifications").
        to_return(:body => fixture("v3/repository_notifications.json"))
      notifications = @client.repository_notifications("sferik/rails_admin")
      expect(notifications.first.id).to eq(1)
      expect(notifications.first.unread).to be_true
    end

  end

  describe ".mark_notifications_as_read" do

    it "returns true when notifications are marked as read" do
      stub_put("https://api.github.com/notifications").
        to_return(:status => 205)
      result = @client.mark_notifications_as_read
      expect(result).to be_true
    end

    it "returns false when unsuccessful" do
      stub_put("https://api.github.com/notifications").
        to_return(:status => 500)
      result = @client.mark_notifications_as_read
      expect(result).to be_false
    end

  end

  describe ".mark_repository_notifications_as_read" do

    it "returns true when notifications for a repo are marked as read" do
      stub_put("https://api.github.com/repos/sferik/rails_admin/notifications").
        to_return(:status => 205)
      result = @client.mark_repository_notifications_as_read("sferik/rails_admin")
      expect(result).to be_true
    end

    it "returns false when unsuccessful" do
      stub_put("https://api.github.com/repos/sferik/rails_admin/notifications").
        to_return(:status => 500)
      result = @client.mark_repository_notifications_as_read("sferik/rails_admin")
      expect(result).to be_false
    end

  end

  describe ".notifications_thread" do

    it "returns notifications for a specific thread" do
      stub_get("https://api.github.com/notifications/threads/1573564").
        to_return(:body => fixture('v3/notification_thread.json'))
      notification = @client.notifications_thread(1573564)
      expect(notification.id).to eq("1573564")
      expect(notification.unread).to be_true
    end

  end

  describe ".mark_thread_as_read" do

    it "marks a thread as read" do
      stub_patch("https://api.github.com/notifications/threads/1573564").
        to_return(:status => 205)
      result = @client.mark_thread_as_read(1573564)
      expect(result).to be_true
    end

    it "returns false when unsuccessful" do
      stub_patch("https://api.github.com/notifications/threads/1573564").
        to_return(:status => 500)
      result = @client.mark_thread_as_read(1573564)
      expect(result).to be_false
    end

  end

  describe ".thread_subscription" do

    it "returns a thread subscription" do
      stub_get("https://api.github.com/notifications/threads/1573564").
        to_return(:body => fixture('v3/notification_thread.json'))
      stub_get("https://api.github.com/notifications/threads/1573564/subscription").
        to_return(:body => fixture("v3/thread_subscription.json"))
      subscription = @client.thread_subscription(1573564)
      expect(subscription.subscribed).to be_true
    end

  end

  describe ".update_thread_subscription" do

    it "updates a thread subscription" do
      stub_get("https://api.github.com/notifications/threads/1573564").
        to_return(:body => fixture('v3/notification_thread.json'))
      stub_put("https://api.github.com/notifications/threads/1573564/subscription").
        to_return(:body => fixture("v3/thread_subscription_update.json"))
      subscription = @client.update_thread_subscription(1573564, :subscribed => true)
      expect(subscription.subscribed).to be_true
    end

  end

  describe ".delete_thread_subscription" do

    it "returns true with successful thread deletion" do
      stub_get("https://api.github.com/notifications/threads/1573564").
        to_return(:body => fixture('v3/notification_thread.json'))
      stub_delete("https://api.github.com/notifications/threads/1573564/subscription").
        to_return(:status => 204)
      result = @client.delete_thread_subscription(1573564)
      expect(result).to be_true
    end

    it "returns false when subscription deletion fails" do
      stub_get("https://api.github.com/notifications/threads/1573564").
        to_return(:body => fixture('v3/notification_thread.json'))
      stub_delete("https://api.github.com/notifications/threads/1573564/subscription").
        to_return(:status => 500)
      result = @client.delete_thread_subscription(1573564)
      expect(result).to be_false
    end


  end

end

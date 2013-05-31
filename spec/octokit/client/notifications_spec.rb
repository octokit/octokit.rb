require 'helper'

describe Octokit::Client::Notifications do

  before do
    Octokit.reset!
    VCR.insert_cassette 'notifications'
    @client = basic_auth_client
  end

  after do
    Octokit.reset!
    VCR.eject_cassette
  end

  describe ".notifications" do
    it "lists the notifications for the current user" do
      notifications = @client.notifications
      expect(notifications).to be_kind_of Array
      assert_requested :get, basic_github_url("/notifications")
    end
  end # .notifications

  describe ".repository_notifications" do
    it "lists all notifications for a repository" do
      notifications = @client.repository_notifications("pengwynn/api-sandbox")
      expect(notifications).to be_kind_of Array
      assert_requested :get, basic_github_url("/repos/pengwynn/api-sandbox/notifications")
    end
  end # .repository_notifications

  describe ".mark_notifications_as_read" do
    it "returns true when notifications are marked as read" do
      result = @client.mark_notifications_as_read
      expect(result).to be_true
      assert_requested :put, basic_github_url("/notifications")
    end
  end # .mark_notifications_as_read

  describe ".mark_repository_notifications_as_read" do
    it "returns true when notifications for a repo are marked as read" do
      result = @client.mark_repository_notifications_as_read("pengwynn/api-sandbox")
      expect(result).to be_true
      assert_requested :put, basic_github_url("/repos/pengwynn/api-sandbox/notifications")
    end
  end # .mark_repository_notifications_as_read

  describe ".thread_notifications" do
    it "returns notifications for a specific thread" do
      notifications = @client.thread_notifications(509517)
      assert_requested :get, basic_github_url("/notifications/threads/509517")
    end
  end # .thread_notifications

  describe ".mark_thread_as_read" do
    it "marks a thread as read" do
      result = @client.mark_thread_as_read(509517)
      assert_requested :patch, basic_github_url("/notifications/threads/509517")
    end
  end # .mark_thread_as_read

  describe ".thread_subscription" do
    xit "returns a thread subscription" do
      subscription = @client.thread_subscription(509517)
      assert_requested :get, basic_github_url("/notifications/threads/509517/subscription")
    end
  end # .thread_subscription

  describe ".update_thread_subscription" do
    xit "updates a thread subscription" do
      subscription = @client.update_thread_subscription(509517, :subscribed => true)
      assert_requested :put, basic_github_url("/notifications/threads/509517/subscription")
    end
  end # .update_thread_subscription

  describe ".delete_thread_subscription" do
    xit "returns true with successful thread deletion" do
      result = @client.delete_thread_subscription(509517)
      assert_requested :delete, basic_github_url("/notifications/threads/509517/subscription")
    end
  end # .delete_thread_subscription

end

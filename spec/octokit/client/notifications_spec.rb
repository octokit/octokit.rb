require 'helper'

describe Octokit::Client::ActivityNotifications do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".user_notifications", :vcr do
    it "lists the notifications for the current user" do
      notifications = @client.user_notifications
      expect(notifications).to be_kind_of Array
      assert_requested :get, github_url("/notifications")
    end
  end # .user_notifications

  describe ".user_repo_notifications", :vcr do
    it "lists all notifications for a repository" do
      notifications = @client.user_repo_notifications(@test_repo)
      expect(notifications).to be_kind_of Array
      assert_requested :get, github_url("/repos/#{@test_repo}/notifications")
    end
  end # .user_repo_notifications

  describe ".mark_notifications_as_read", :vcr do
    it "returns true when notifications are marked as read" do
      result = @client.mark_notifications_as_read
      expect(result).to be true
      assert_requested :put, github_url("/notifications")
    end
  end # .mark_notifications_as_read

  describe ".mark_repo_notifications_as_read", :vcr do
    it "returns true when notifications for a repo are marked as read" do
      result = @client.mark_repo_notifications_as_read(@test_repo)
      expect(result).to be true
      assert_requested :put, github_url("/repos/#{@test_repo}/notifications")
    end
  end # .mark_repo_notifications_as_read

  context "with thread" do
    before(:each) do
      @thread_id = @client.user_repo_notifications(@test_repo, :all => true).last.id
    end

    describe ".thread", :vcr do
      it "returns notifications for a specific thread" do
        @client.thread(@thread_id)
        assert_requested :get, github_url("/notifications/threads/#{@thread_id}")
      end
    end # .thread

    describe ".mark_thread_as_read", :vcr do
      it "marks a thread as read" do
        @client.mark_thread_as_read(@thread_id)
        assert_requested :patch, github_url("/notifications/threads/#{@thread_id}")
      end
    end # .mark_thread_as_read

    context "with subscription", :vcr do
      before do
        @client.set_thread_subscription(@thread_id, :subscribed => true)
      end

      describe ".user_thread_subscription" do
        it "returns a thread subscription" do
          @client.user_thread_subscription(@thread_id)
          assert_requested :get, github_url("/notifications/threads/#{@thread_id}/subscription")
        end
      end # .user_thread_subscription

      describe ".set_thread_subscription" do
        it "sets a thread subscription" do
          assert_requested :put, github_url("/notifications/threads/#{@thread_id}/subscription")
        end
      end # .set_thread_subscription

      describe ".delete_thread_subscription" do
        it "returns true with successful thread deletion" do
          @client.delete_thread_subscription(@thread_id)
          assert_requested :delete, github_url("/notifications/threads/#{@thread_id}/subscription")
        end
      end # .delete_thread_subscription
    end # with subscription
  end # with thread
end

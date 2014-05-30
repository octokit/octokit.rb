require 'helper'

describe Octokit::Client::Notifications do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".notifications", :vcr do
    it "lists the notifications for the current user" do
      notifications = @client.notifications
      expect(notifications).to be_kind_of Array
      assert_requested :get, github_url("/notifications")
    end
  end # .notifications

  describe ".repository_notifications", :vcr do
    it "lists all notifications for a repository" do
      notifications = @client.repository_notifications(@test_repo)
      expect(notifications).to be_kind_of Array
      assert_requested :get, github_url("/repos/#{@test_repo}/notifications")
    end
  end # .repository_notifications

  describe ".mark_notifications_as_read", :vcr do
    it "returns true when notifications are marked as read" do
      result = @client.mark_notifications_as_read
      expect(result).to be true
      assert_requested :put, github_url("/notifications")
    end
  end # .mark_notifications_as_read

  describe ".mark_repository_notifications_as_read", :vcr do
    it "returns true when notifications for a repo are marked as read" do
      result = @client.mark_repository_notifications_as_read(@test_repo)
      expect(result).to be true
      assert_requested :put, github_url("/repos/#{@test_repo}/notifications")
    end
  end # .mark_repository_notifications_as_read

  context "with thread" do
    before(:each) do
      @thread_id = @client.repository_notifications(@test_repo, :all => true).last.id
    end

    describe ".thread_notifications", :vcr do
      it "returns notifications for a specific thread" do
        @client.thread_notifications(@thread_id)
        assert_requested :get, github_url("/notifications/threads/#{@thread_id}")
      end
    end # .thread_notifications

    describe ".mark_thread_as_read", :vcr do
      it "marks a thread as read" do
        @client.mark_thread_as_read(@thread_id)
        assert_requested :patch, github_url("/notifications/threads/#{@thread_id}")
      end
    end # .mark_thread_as_read

    context "with subscription", :vcr do
      before do
        @client.update_thread_subscription(@thread_id, :subscribed => true)
      end

      describe ".thread_subscription" do
        it "returns a thread subscription" do
          @client.thread_subscription(@thread_id)
          assert_requested :get, github_url("/notifications/threads/#{@thread_id}/subscription")
        end
      end # .thread_subscription

      describe ".update_thread_subscription" do
        it "updates a thread subscription" do
          assert_requested :put, github_url("/notifications/threads/#{@thread_id}/subscription")
        end
      end # .update_thread_subscription

      describe ".delete_thread_subscription" do
        it "returns true with successful thread deletion" do
          @client.delete_thread_subscription(@thread_id)
          assert_requested :delete, github_url("/notifications/threads/#{@thread_id}/subscription")
        end
      end # .delete_thread_subscription
    end # with subscription
  end # with thread
end

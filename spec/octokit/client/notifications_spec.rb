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

  describe ".mark_notifications_as_read", :vcr do
    it "returns true when notifications are marked as read" do
      result = @client.mark_notifications_as_read
      expect(result).to be_true
      assert_requested :put, github_url("/notifications")
    end
  end # .mark_notifications_as_read

  context "with repository" do
    before do
      @test_repo = setup_test_repo.full_name
    end

    after do
      teardown_test_repo @test_repo
    end

    describe ".repository_notifications", :vcr do
      it "lists all notifications for a repository" do
        notifications = @client.repository_notifications(@test_repo)
        expect(notifications).to be_kind_of Array
        assert_requested :get, github_url("/repos/#{@test_repo}/notifications")
      end
    end # .repository_notifications

    describe ".mark_repository_notifications_as_read", :vcr do
      it "returns true when notifications for a repo are marked as read" do
        result = @client.mark_repository_notifications_as_read(@test_repo)
        expect(result).to be_true
        assert_requested :put, github_url("/repos/#{@test_repo}/notifications")
      end
    end # .mark_repository_notifications_as_read
  end # with repository

  context "with thread" do
    before(:each) do
      @thread_id = '263534'
    end

    describe ".thread_notifications" do
      it "returns notifications for a specific thread" do
        request = stub_get(github_url("/notifications/threads/#{@thread_id}"))
        notifications = @client.thread_notifications(@thread_id)
        assert_requested request
      end
    end # .thread_notifications

    describe ".mark_thread_as_read" do
      it "marks a thread as read" do
        request = stub_patch(github_url("/notifications/threads/#{@thread_id}"))
        result = @client.mark_thread_as_read(@thread_id)
        assert_requested request
      end
    end # .mark_thread_as_read

    describe ".thread_subscription" do
      it "returns a thread subscription" do
        request = stub_get(github_url("/notifications/threads/#{@thread_id}/subscription"))
        subscription = @client.thread_subscription(@thread_id)
        assert_requested request
      end
    end # .thread_subscription

    describe ".update_thread_subscription" do
      it "updates a thread subscription" do
        request = stub_put(github_url("/notifications/threads/#{@thread_id}/subscription"))
        subscription = @client.update_thread_subscription(@thread_id, :subscribed => true)
        assert_requested request
      end
    end # .update_thread_subscription

    describe ".delete_thread_subscription" do
      it "returns true with successful thread deletion" do
        request = stub_delete(github_url("/notifications/threads/#{@thread_id}/subscription"))
        result = @client.delete_thread_subscription(@thread_id)
        assert_requested request
      end
    end # .delete_thread_subscription
  end # with thread
end # Octokit::Client::Notifications

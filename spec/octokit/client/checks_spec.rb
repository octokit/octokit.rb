require "helper"

describe Octokit::Client::Checks, :vcr do
  before do
    Octokit.reset!
    @client = oauth_client
    @repo = "laserlemon/octokit-test-repo"
    @commit = "58729b0c56c372e71494aa7f26014d24dcbc691e"
    @branch = "master" # Equivalent to @commit
    @tag = "v1" # Equivalent to @commit
    @check_run_name = "octokit-test-check-run"
    @check_run_id = 50937418
    @check_suite_id = 50031988
  end

  # describe ".check_run" do
  #   it "returns a check run" do
  #     check_run = @client.check_run("probot/probot", 48583805, accept: preview_header)

  #     expect(check_run.head_sha).to eq("ca853910cddc7787cf60e0f7255ebdb341d1f1b4")
  #     expect(check_run.url).to eq("https://api.github.com/repos/probot/probot/check-runs/48583805")
  #     assert_requested :get, github_url("/repos/probot/probot/check-runs/48583805")
  #   end
  # end

  describe ".create_check_run" do
    it "creates a check run" do
      @client.create_check_run(
        @repo,
        @check_run_name,
        @commit,
        accept: preview_header,
      )

      assert_requested :post, github_url("/repos/#{@repo}/check-runs")
    end

    it "returns the check run" do
      check_run = @client.create_check_run(
        @repo,
        @check_run_name,
        @commit,
        accept: preview_header,
      )

      expect(check_run.name).to eq(@check_run_name)
      expect(check_run.head_sha).to eq(@commit)
      expect(check_run.status).to eq("queued")
    end
  end

  describe ".update_check_run" do
    it "updates the check run" do
      @client.update_check_run(
        @repo,
        @check_run_id,
        accept: preview_header,
        status: "in_progress",
      )

      assert_requested :patch, github_url("/repos/#{@repo}/check-runs/#{@check_run_id}")
    end

    it "returns the check run" do
      check_run = @client.update_check_run(
        @repo,
        @check_run_id,
        accept: preview_header,
        status: "in_progress",
      )

      expect(check_run.id).to eq(@check_run_id)
      expect(check_run.status).to eq("in_progress")
    end
  end

  describe ".check_runs_for_ref" do
    it "returns check runs for a commit" do
      result = @client.check_runs_for_ref(
        @repo,
        @commit,
        accept: preview_header,
      )

      expect(result.total_count).to eq(1)
      expect(result.check_runs).to be_a(Array)
      expect(result.check_runs.count).to eq(1)
      expect(result.check_runs[0].id).to eq(@check_run_id)
    end

    it "returns check runs for a branch" do
      result = @client.check_runs_for_ref(
        @repo,
        @branch,
        accept: preview_header,
      )

      expect(result.total_count).to eq(1)
      expect(result.check_runs).to be_a(Array)
      expect(result.check_runs.count).to eq(1)
      expect(result.check_runs[0].id).to eq(@check_run_id)
    end

    it "returns check runs for a tag" do
      result = @client.check_runs_for_ref(
        @repo,
        @tag,
        accept: preview_header,
      )

      expect(result.total_count).to eq(1)
      expect(result.check_runs).to be_a(Array)
      expect(result.check_runs.count).to eq(1)
      expect(result.check_runs[0].id).to eq(@check_run_id)
    end

    it "filters by status" do
      result = @client.check_runs_for_ref(
        @repo,
        @commit,
        accept: preview_header,
        status: "completed",
      )

      expect(result.total_count).to eq(0)
      expect(result.check_runs).to be_a(Array)
      expect(result.check_runs.count).to eq(0)
    end
  end

  describe ".check_runs_for_check_suite" do
    it "returns check runs for a check suite" do
      result = @client.check_runs_for_check_suite(
        @repo,
        @check_suite_id,
        accept: preview_header,
      )

      expect(result.total_count).to eq(1)
      expect(result.check_runs).to be_a(Array)
      expect(result.check_runs.count).to eq(1)
      expect(result.check_runs[0].id).to eq(@check_run_id)
    end

    it "filters by status" do
      result = @client.check_runs_for_check_suite(
        @repo,
        @check_suite_id,
        accept: preview_header,
        status: "completed",
      )

      expect(result.total_count).to eq(0)
      expect(result.check_runs).to be_a(Array)
      expect(result.check_runs.count).to eq(0)
    end
  end

  describe ".check_run" do
    it "returns the check run" do
      check_run = @client.check_run(
        @repo,
        @check_run_id,
        accept: preview_header,
      )

      expect(check_run.id).to eq(@check_run_id)
      expect(check_run.name).to eq(@check_run_name)
    end
  end

  describe ".check_run_annotations" do
    it "returns annotations for the check run" do
      annotations = @client.check_run_annotations(
        @repo,
        @check_run_id,
        accept: preview_header,
      )

      expect(annotations).to be_a(Array)
      expect(annotations.count).to eq(1)
      expect(annotations[0].path).to eq("README.md")
    end
  end

  private

  def preview_header
    Octokit::Preview::PREVIEW_TYPES[:checks]
  end
end

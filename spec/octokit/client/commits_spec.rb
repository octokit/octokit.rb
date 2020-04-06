require 'helper'

describe Octokit::Client::Commits do

  before do
    Octokit.reset!
    @client = oauth_client
    @branch = "master"
    @tag = "v1.0"
  end

  describe ".commits", :vcr do
    it "returns all commits" do
      commits = @client.commits(@test_repo)
      expect(commits.first.author).not_to be_nil
      assert_requested :get, github_url("/repos/#{@test_repo}/commits")
    end
    it "handles the sha option" do
      @client.commits(@test_repo, :sha => "master")
      assert_requested :get, github_url("/repos/#{@test_repo}/commits?sha=master")
    end
  end # .commits

  context "with commit" do

    before do
      @commit_id = @client.commits(@test_repo).first.sha
    end

    describe ".commit", :vcr do
      it "returns a commit" do
        commit = @client.commit(@test_repo, @commit_id)
        expect(commit.author.login).not_to be_nil
        assert_requested :get, github_url("/repos/#{@test_repo}/commits/#{@commit_id}")
      end
    end # .commit

    describe ".ref_statuses", :vcr do
      it "lists commit statuses" do
        statuses = Octokit.ref_statuses(@test_repo, @commit_id)
        expect(statuses).to be_kind_of Array
        assert_requested :get, github_url("/repos/#{@test_repo}/commits/#{@commit_id}/statuses")
      end
    end # .ref_statuses

    describe ".ref_combined_status", :vcr do
      it "gets a combined status" do
        status = Octokit.ref_combined_status(@test_repo, @commit_id)
        expect(status.sha).to eq(@commit_id)
        expect(status.statuses).to be_kind_of Array
        assert_requested :get, github_url("/repos/#{@test_repo}/commits/#{@commit_id}/status")
      end
    end # .ref_combined_status

    describe ".commit_comments", :vcr do
      it "returns a list of comments for a specific commit" do
        commit_comments = @client.commit_comments(@test_repo, @commit_id)
        assert_requested :get, github_url("/repos/#{@test_repo}/commits/#{@commit_id}/comments")
      end
    end # .commit_comments

    describe ".create_commit_comment", :vcr do
      it "creates a commit comment" do
        @commit_comment = @client.create_commit_comment \
          @test_repo,
          @commit_id,
          ":metal:\n:sparkles:\n:cake:"

        # expect(@commit_comment.user.login).to eq(test_github_login)
        assert_requested :post, github_url("/repos/#{@test_repo}/commits/#{@commit_id}/comments")
      end
    end # .create_commit_comment

    describe ".commit_pulls", :vcr do
      it "returns a list of all pull requests associated with a commit" do
        pulls = @client.commit_pull_requests(
          @test_repo,
          @commit_id,
          accept: preview_header(:commit_pulls),
        )
        assert_requested :get, github_url("/repos/#{@test_repo}/commits/#{@commit_id}/pulls")
      end
    end # .commit_pulls

    describe ".commit_branches", :vcr do
      it "returns a list of all branches associated with a commit" do
        branches = @client.commit_branches(
          @test_repo,
          @commit_id,
          accept: preview_header(:commit_branches),
        )
        assert_requested :get, github_url("/repos/#{@test_repo}/commits/#{@commit_id}/branches-where-head")
      end
    end # .commit_branches

    describe ".ref_checks", :vcr do
      it "returns check runs for a commit" do
        result = @client.ref_checks(
          @test_repo,
          @commit_id,
          accept: preview_header(:checks),
        )

        expect(result.check_runs).to be_a(Array)
        assert_requested :get, github_url("/repos/#{@test_repo}/commits/#{@commit_id}/check-runs")
      end

      it "returns check runs for a branch" do
        result = @client.ref_checks(
          @test_repo,
          @branch,
          accept: preview_header(:checks),
        )

        expect(result.check_runs).to be_a(Array)
        assert_requested :get, github_url("/repos/#{@test_repo}/commits/#{@branch}/check-runs")
      end

      it "returns check runs for a tag" do
        result = @client.ref_checks(
          @test_repo,
          @tag,
          accept: preview_header(:checks),
        )

        expect(result.check_runs).to be_a(Array)
        assert_requested :get, github_url("/repos/#{@test_repo}/commits/#{@tag}/check-runs")
      end
    end # .ref_checks

    describe ".ref_suites", :vcr do
      it "returns check suites for a commit" do
        result = @client.ref_suites(
          @test_repo,
          @commit_id,
          accept: preview_header(:checks),
        )

        expect(result.check_suites).to be_a(Array)
        assert_requested :get, github_url("/repos/#{@test_repo}/commits/#{@commit_id}/check-suites")
      end

      it "returns check suites for a branch" do
        result = @client.ref_suites(
          @test_repo,
          @branch,
          accept: preview_header(:checks),
        )

        expect(result.check_suites).to be_a(Array)
        assert_requested :get, github_url("/repos/#{@test_repo}/commits/#{@branch}/check-suites")
      end

      it "returns check suites for a tag" do
        result = @client.ref_suites(
          @test_repo,
          @tag,
          accept: preview_header(:checks),
        )

        expect(result.check_suites).to be_a(Array)
        assert_requested :get, github_url("/repos/#{@test_repo}/commits/#{@tag}/check-suites")
      end
    end # .ref_suites
  end # with commit

  private

  def preview_header(type)
    Octokit::Preview::PREVIEW_TYPES[type]
  end
end

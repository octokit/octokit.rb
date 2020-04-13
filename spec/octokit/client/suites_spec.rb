require "helper"

describe Octokit::Client::Suites, :vcr do
  before do
    Octokit.reset!

    @jwt_client = Octokit::Client.new(:bearer_token => new_jwt_token)
    use_vcr_placeholder_for(@jwt_client.bearer_token, '<JWT_BEARER_TOKEN>')

    token = @jwt_client.create_app_installation_access_token(
      test_github_integration_installation,
      accept: preview_header(:integrations)
    ).token
    @client = Octokit::Client.new(:access_token => token)
  end

  context "with check suite" do
    before(:each) do
      branch = @client.branch(@test_repo, "master")
      # doesn't work with @client
      commit = oauth_client.create_commit(@test_repo,
                                          "help test create_check_suite",
                                          branch.commit.commit.tree.sha)
      @commit_sha = commit.sha

      @check_suite = @client.create_check_suite(
        @test_repo,
        commit.sha,
        accept: preview_header(:checks),
      )
    end

    describe ".create_check_suite" do
      it "creates a check suite" do
        assert_requested :post, repo_url("check-suites")
        expect(@check_suite.head_sha).to eq(@commit_sha)
        expect(@check_suite.status).to eq("queued")
      end
    end

    describe ".check_suite" do
      it "returns the check suite" do
        check_suite = @client.check_suite(
          @test_repo,
          @check_suite.id,
          accept: preview_header(:checks),
        )

        expect(check_suite.id).to eq(@check_suite.id)
        expect(check_suite.head_sha).to eq(@commit_sha)
      end
    end

    describe ".rerequest_check_suite" do
      it "requests the check suite again" do
        result = @client.rerequest_check_suite(
          @test_repo,
          @check_suite.id,
          accept: preview_header(:checks),
        )

        assert_requested :post, repo_url("check-suites/#{@check_suite.id}/rerequest")
        expect(result).to eq(true)
      end
    end

    context "with check run and suite" do
      before(:each) do
        check_name = "octokit-test-check"
        check_run = @client.create_check(
          @test_repo,
          check_name,
          @commit_sha,
          accept: preview_header(:checks),
        )
        @check_run_id = check_run.id
      end

      describe ".suite_checks" do
        it "returns check runs for a check suite" do
          result = @client.suite_checks(
            @test_repo,
            @check_suite.id,
            accept: preview_header(:checks),
          )

          expect(result.total_count).to eq(1)
          expect(result.check_runs).to be_a(Array)
          expect(result.check_runs.count).to eq(1)
          expect(result.check_runs[0].id).to eq(@check_run_id)
        end

        it "filters by status" do
          result = @client.suite_checks(
            @test_repo,
            @check_suite.id,
            accept: preview_header(:checks),
            status: "completed",
          )

          expect(result.total_count).to eq(0)
          expect(result.check_runs).to be_a(Array)
          expect(result.check_runs.count).to eq(0)

          result = @client.suite_checks(
            @test_repo,
            @check_suite.id,
            accept: preview_header(:checks),
            status: "queued",
          )

          expect(result.total_count).to eq(1)
          expect(result.check_runs).to be_a(Array)
          expect(result.check_runs.count).to eq(1)
          expect(result.check_runs[0].id).to eq(@check_run_id)
        end
      end
    end
  end

  describe ".set_suites_preferences" do
    it "sets check suite preferences" do
      @client.set_suites_preferences(
        @test_repo,
        accept: preview_header(:checks),
        auto_trigger_checks: [
          {
            app_id: test_github_integration,
            setting: false,
          },
        ],
      )

      assert_requested :patch, repo_url("check-suites/preferences")
    end
  end # .set_suite_preferences

  private

  def preview_header(type)
    Octokit::Preview::PREVIEW_TYPES[type]
  end

  def repo_url(repo_path)
    github_url(["repos", @test_repo, repo_path].join("/"))
  end
end

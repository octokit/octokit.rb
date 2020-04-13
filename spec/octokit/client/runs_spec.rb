require "helper"

describe Octokit::Client::Runs, :vcr do
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

  context "with commit" do
    before(:each) do
      commits = @client.commits(@test_repo)
      @commit_sha = commits.first.sha
      @check_name = "octokit-test-check"
    end

    describe ".create_check" do
      it "creates a check run" do
        check_run = @client.create_check(
          @test_repo,
          @check_name,
          @commit_sha,
          accept: preview_header(:checks),
        )

        assert_requested :post, repo_url("check-runs")

        expect(check_run.name).to eq(@check_name)
        expect(check_run.head_sha).to eq(@commit_sha)
        expect(check_run.status).to eq("queued")
      end
    end # .create_check

    context "with check run" do
      before(:each) do
        check_run = @client.create_check(
          @test_repo,
          @check_name,
          @commit_sha,
          accept: preview_header(:checks),
        )
        @check_run_id = check_run.id
        @path = "README.md"
      end

      describe ".update_check" do
        it "updates the check run" do
          check_run = @client.update_check(
            @test_repo,
            @check_run_id,
            accept: preview_header(:checks),
            completed_at: "2019-01-17T14:52:51Z",
            conclusion: "success",
            output: {
              annotations: [
                {
                  annotation_level: "notice",
                  end_line: 1,
                  message: "Looks good!",
                  path: @path,
                  start_line: 1,
                },
              ],
              summary: "Everything checks out.",
              title: "Octokit Check",
            },
          )

          assert_requested :patch, repo_url("check-runs/#{@check_run_id}")

          expect(check_run.id).to eq(@check_run_id)
          expect(check_run.status).to eq("completed")
        end
      end # .update_check

      describe ".check" do
        it "returns the check run" do
          check_run = @client.check(
            @test_repo,
            @check_run_id,
            accept: preview_header(:checks),
          )

          expect(check_run.id).to eq(@check_run_id)
          expect(check_run.name).to eq(@check_name)
          expect(check_run.head_sha).to eq(@commit_sha)
        end
      end # check

      context "with annotation" do

        before(:each) do
          check_run = @client.update_check(
            @test_repo,
            @check_run_id,
            accept: preview_header(:checks),
            completed_at: "2019-01-17T14:52:51Z",
            conclusion: "success",
            output: {
              annotations: [
                {
                  annotation_level: "notice",
                  end_line: 1,
                  message: "Looks good!",
                  path: @path,
                  start_line: 1,
                },
              ],
              summary: "Everything checks out.",
              title: "Octokit Check",
            },
          )
        end

        describe ".check_annotations" do
          it "returns annotations for the check run" do
            annotations = @client.check_annotations(
              @test_repo,
              @check_run_id,
              accept: preview_header(:checks),
            )

            expect(annotations).to be_a(Array)
            expect(annotations.count).to eq(1)
            expect(annotations[0].path).to eq(@path)
          end
        end # .check_annotations
      end # with annotation
    end # with check run
  end # with commit

  private

  def preview_header(type)
    Octokit::Preview::PREVIEW_TYPES[type]
  end

  def repo_url(repo_path)
    github_url(["repos", @test_repo, repo_path].join("/"))
  end
end

# frozen_string_literal: true

require 'helper'

describe Octokit::Client::PullRequests do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe '.pull_requests', :vcr do
    it 'lists all pull requests' do
      pulls = @client.pulls('octokit/octokit.rb')
      expect(pulls).to be_kind_of Array
      assert_requested :get, github_url('/repos/octokit/octokit.rb/pulls')
    end
    it 'lists all pull requests with state option' do
      pulls = @client.pulls('octokit/octokit.rb', state: 'open')
      expect(pulls).to be_kind_of Array
      assert_requested :get, github_url('/repos/octokit/octokit.rb/pulls?state=open')
    end
  end # .pull_requests

  context 'methods that require a new pull' do
    before(:each) do
      @pull = @client.create_pull_request(*arguments_to_create_pull_request)
    end

    after(:each) do
      @client.close_pull_request(@test_repo, @pull.number)
    end

    let(:arguments_to_create_pull_request) do
      [@test_repo, 'master', 'branch-for-pr', 'A new PR', 'The Body']
    end

    describe '.create_pull_request', :vcr do
      it 'creates a pull request' do
        expect(@pull.title).to eq('A new PR')
        assert_requested :post, github_url("/repos/#{@test_repo}/pulls")
      end

      context 'without body argument' do
        let(:arguments_to_create_pull_request) do
          super()[0..-2]
        end

        it 'creates a pull request without body argument' do
          expect(@pull.body).to be_nil
          assert_requested :post, github_url("/repos/#{@test_repo}/pulls")
        end
      end
    end # .create_pull_request

    describe '.pull_request', :vcr do
      it 'returns a pull request' do
        pull = @client.pull(@test_repo, @pull.number)
        expect(pull.title).to eq('A new PR')
        assert_requested :get, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}")
      end
    end # .pull_request

    describe '.update_pull_request', :vcr do
      it 'updates a pull request' do
        @client.update_pull_request(@test_repo, @pull.number, 'New title', 'Updated body')
        assert_requested :patch, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}")
      end
    end # .update_pull_request

    describe '.pull_merged?', :vcr do
      it 'returns whether the pull request has been merged' do
        merged = @client.pull_merged?(@test_repo, @pull.number)
        expect(merged).not_to be true
        assert_requested :get, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}/merge")
      end
    end # .pull_merged?

    context 'methods requiring a pull request comment' do
      before do
        new_comment = {
          body: 'Hawt',
          commit_id: '9bf22dff54fd6a7650230b70417b55e8cccfc4f2',
          path: 'test.md',
          position: 1
        }
        @comment = @client.create_pull_request_comment \
          @test_repo,
          @pull.number,
          new_comment[:body],
          new_comment[:commit_id],
          new_comment[:path],
          new_comment[:position]
      end

      describe '.create_pull_request_comment', :vcr do
        it 'creates a new comment on a pull request' do
          assert_requested :post, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}/comments")
        end
      end # .create_pull_request_comment

      describe '.create_pull_request_comment_reply', :vcr do
        it 'creates a new reply to a pull request comment' do
          new_comment = {
            body: 'done.',
            in_reply_to: @comment.id
          }
          reply = @client.create_pull_request_comment_reply(@test_repo, @pull.number, new_comment[:body], new_comment[:in_reply_to])
          assert_requested :post, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}/comments"), times: 2
          expect(reply.body).to eq(new_comment[:body])
        end
      end # .create_pull_request_comment_reply

      describe '.update_pull_request_comment', :vcr do
        it 'updates a pull request comment' do
          comment = @client.update_pull_request_comment(@test_repo, @comment.id, ':shipit:')
          expect(comment.body).to eq(':shipit:')
          assert_requested :patch, github_url("/repos/#{@test_repo}/pulls/comments/#{@comment.id}")
        end
      end # .update_pull_request_comment

      describe '.delete_pull_request_comment', :vcr do
        it 'deletes a pull request comment' do
          result = @client.delete_pull_request_comment(@test_repo, @comment.id)
          expect(result).to eq(true)
          assert_requested :delete, github_url("/repos/#{@test_repo}/pulls/comments/#{@comment.id}")
        end
      end # .delete_pull_request_comment
    end # pull request comment methods

    describe '.close_pull_request', :vcr do
      it 'closes a pull request' do
        response = @client.close_pull_request(@test_repo, @pull.number)
        expect(response.state).to eq('closed')
        assert_requested :patch, github_url("/repos/#{@test_repo}/pulls/#{@pull.number}")
      end
    end
  end # new @pull methods

  # stub this so we don't have to set up new fixture data
  describe '.merge_pull_request' do
    it 'merges the pull request' do
      request = stub_put(github_url('/repos/api-playground/api-sandbox/pulls/123/merge'))
      @client.merge_pull_request('api-playground/api-sandbox', 123)
      assert_requested request
    end
  end # .merge_pull_request

  describe '.create_pull_request_for_issue', :vcr do
    it 'creates a pull request and attach it to an existing issue' do
      issue = @client.create_issue(@test_repo, 'A new issue', 'Gonna turn this into a PR')
      pull = @client.create_pull_request_for_issue(@test_repo, 'master', 'some-fourth-branch', issue.number)
      assert_requested :post, github_url("/repos/#{@test_repo}/pulls")

      # cleanup so we can re-run test with blank cassette
      @client.close_pull_request(@test_repo, pull.number)
    end
  end # .create_pull_request_for_issue

  describe '.pull_requests_comments', :vcr do
    it 'returns all comments on all pull requests' do
      comments = @client.pull_requests_comments('octokit/octokit.rb')
      expect(comments).to be_kind_of Array
      assert_requested :get, github_url('/repos/octokit/octokit.rb/pulls/comments')
    end
  end # .pull_requests_comments

  describe '.pull_request_commits', :vcr do
    it 'returns the commits for a pull request' do
      commits = @client.pull_commits('octokit/octokit.rb', 67)
      expect(commits).to be_kind_of Array
      assert_requested :get, github_url('/repos/octokit/octokit.rb/pulls/67/commits')
    end
  end # .pull_request_commits

  describe '.pull_request_files', :vcr do
    it 'lists files for a pull request' do
      files = @client.pull_request_files('octokit/octokit.rb', 67)
      file = files.first
      expect(file.filename).to eq('lib/octokit/configuration.rb')
      expect(file.additions).to eq(4)
      assert_requested :get, github_url('/repos/octokit/octokit.rb/pulls/67/files')
    end
  end # .pull_request_files

  describe '.pull_request_comments', :vcr do
    it 'returns the comments for a pull request' do
      comments = @client.pull_comments('octokit/octokit.rb', 67)
      expect(comments).to be_kind_of Array
      assert_requested :get, github_url('/repos/octokit/octokit.rb/pulls/67/comments')
    end
  end # .pull_request_comments

  describe '.pull_request_comment', :vcr do
    it 'returns a comment on a pull request' do
      comment = @client.pull_request_comment('octokit/octokit.rb', 1_903_950)
      expect(comment.body).not_to be_nil
      assert_requested :get, github_url('/repos/octokit/octokit.rb/pulls/comments/1903950')
    end
  end # .pull_request_comment
end

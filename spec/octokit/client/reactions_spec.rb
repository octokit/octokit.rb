# frozen_string_literal: true

require 'helper'

describe Octokit::Client::Reactions do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  context 'with repository', :vcr do
    before(:each) do
      @repo = @client.create_repository('an-repo', auto_init: true)
    end

    after(:each) do
      begin
        @client.delete_repository(@repo.full_name)
      rescue Octokit::NotFound
      end
    end

    context 'with commit comment' do
      before do
        @commit = @client.commits(@repo.full_name).last.rels[:self].get.data
        @commit_comment = @client.create_commit_comment \
          @repo.full_name,
          @commit.sha, ":metal:\n:sparkles:\n:cake:",
          @commit.files.last.filename
      end

      describe '.commit_comment_reactions' do
        it 'returns an Array of reactions' do
          reactions = @client.commit_comment_reactions(@repo.full_name, @commit_comment.id, accept: preview_header)
          expect(reactions).to be_kind_of Array
          assert_requested :get, github_url("/repos/#{@repo.full_name}/comments/#{@commit_comment.id}/reactions")
        end
      end # .commit_comment_reactions

      describe '.create_commit_comment_reaction' do
        it 'creates a reaction' do
          reaction = @client.create_commit_comment_reaction(@repo.full_name, @commit_comment.id, '+1', accept: preview_header)
          expect(reaction.content).to eql('+1')
          assert_requested :post, github_url("/repos/#{@repo.full_name}/comments/#{@commit_comment.id}/reactions")
        end
      end # .create_commit_comment_reaction
    end # with commit comment

    context 'with issue', :vcr do
      before do
        @issue = @client.create_issue(@repo.full_name, 'Migrate issues to v3', 'Move all Issues calls to v3 of the API')
      end

      describe '.issue_reactions' do
        it 'returns an Array of reactions' do
          reactions = @client.issue_reactions(@repo.full_name, @issue.number, accept: preview_header)
          expect(reactions).to be_kind_of Array
          assert_requested :get, github_url("/repos/#{@repo.full_name}/issues/#{@issue.number}/reactions")
        end
      end # .issue_reactions

      describe '.create_issue_reaction' do
        it 'creates a reaction' do
          reaction = @client.create_issue_reaction(@repo.full_name, @issue.number, '+1', accept: preview_header)
          expect(reaction.content).to eql('+1')
          assert_requested :post, github_url("/repos/#{@repo.full_name}/issues/#{@issue.number}/reactions")
        end
      end # .create_issue_reaction

      context 'with issue comment' do
        before do
          @issue_comment = @client.add_comment(@repo.full_name, @issue.number, 'Another test comment')
        end

        describe '.issue_comment_reactions' do
          it 'returns an Array of reactions' do
            reactions = @client.issue_comment_reactions(@repo.full_name, @issue_comment.id, accept: preview_header)
            expect(reactions).to be_kind_of Array
            assert_requested :get, github_url("/repos/#{@repo.full_name}/issues/comments/#{@issue_comment.id}/reactions")
          end
        end # .issue_commit_comment_reactions

        describe '.create_issue_comment_reaction' do
          it 'creates a reaction' do
            reaction = @client.create_issue_comment_reaction(@repo.full_name, @issue_comment.id, '+1', accept: preview_header)
            expect(reaction.content).to eql('+1')
            assert_requested :post, github_url("/repos/#{@repo.full_name}/issues/comments/#{@issue_comment.id}/reactions")
          end
        end # .create_issue_comment_reaction
      end # with issue comment

      context 'with reaction' do
        before do
          @reaction = @client.create_issue_reaction(@repo.full_name, @issue.number, '+1', accept: preview_header)
        end

        describe '.delete_reaction' do
          it 'deletes the reaction' do
            @client.delete_reaction(@reaction.id, accept: preview_header)
            assert_requested :delete, github_url("/reactions/#{@reaction.id}")
          end
        end # .delete_reaction
      end # with reaction
    end # with issue

    context 'with pull request' do
      before do
        master_ref = @client.ref(@repo.full_name, 'heads/master')
        @client.create_ref(@repo.full_name, 'heads/branch-for-pr', master_ref.object.sha)
        @content = @client.create_contents(@repo.full_name, 'lib/test.txt', 'Adding content', 'File Content', branch: 'branch-for-pr')

        args = [@repo.full_name, 'master', 'branch-for-pr', 'A new PR', 'The Body']
        @pull = @client.create_pull_request(*args)
      end

      context 'with pull request review comment' do
        before do
          new_comment = {
            body: 'Looks good!',
            commit_id: @content.commit.sha,
            path: 'lib/test.txt',
            position: 1
          }

          @pull_request_review_comment = @client.create_pull_request_comment \
            @repo.full_name,
            @pull.number,
            new_comment[:body],
            new_comment[:commit_id],
            new_comment[:path],
            new_comment[:position]
        end

        describe '.pull_request_review_comment_reactions' do
          it 'returns an Array of reactions' do
            reactions = @client.pull_request_review_comment_reactions(@repo.full_name, @pull_request_review_comment.id, accept: preview_header)
            expect(reactions).to be_kind_of Array
            assert_requested :get, github_url("/repos/#{@repo.full_name}/pulls/comments/#{@pull_request_review_comment.id}/reactions")
          end
        end # .pull_request_review_comment_reactions

        describe '.create_pull_request_review_comment_reaction' do
          it 'creates a reaction' do
            reaction = @client.create_pull_request_review_comment_reaction(@repo.full_name, @pull_request_review_comment.id, '+1', accept: preview_header)
            expect(reaction.content).to eql('+1')
            assert_requested :post, github_url("/repos/#{@repo.full_name}/pulls/comments/#{@pull_request_review_comment.id}/reactions")
          end
        end # .create_pull_request_review_comment_reaction
      end # with pull request review comment
    end # with pull request
  end # with repository

  private

  def preview_header
    Octokit::Preview::PREVIEW_TYPES[:reactions]
  end
end

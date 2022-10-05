# frozen_string_literal: true

require 'helper'
require 'securerandom'

describe Octokit::Client::Reviews do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe '.pull_request_reviews', :vcr do
    let(:test_pr) { 841 }

    it 'returns a list of all pull request reviews' do
      reviews = @client.pull_request_reviews('octokit/octokit.rb', test_pr)
      expect(reviews).to be_kind_of Array

      requested_url = github_url("/repos/octokit/octokit.rb/pulls/#{test_pr}/reviews")
      assert_requested :get, requested_url
    end
  end

  describe '.pull_request_review', :vcr do
    let(:test_pr) { 825 }
    let(:test_review) { 6_505_518 }

    it 'returns a single pull request review' do
      reviews = @client.pull_request_review('octokit/octokit.rb', test_pr,
                                            test_review)
      expect(reviews).to be_kind_of Sawyer::Resource

      requested_url = github_url("/repos/octokit/octokit.rb/pulls/#{test_pr}/reviews/#{test_review}")
      assert_requested :get, requested_url
    end
  end

  describe '.pull_request_review_comments', :vcr do
    let(:test_pr) { 825 }
    let(:test_review) { 6_505_518 }

    it 'returns all comments for a single review' do
      reviews = @client.pull_request_review_comments('octokit/octokit.rb',
                                                     test_pr, test_review)
      expect(reviews).to be_kind_of Array

      requested_url = github_url("/repos/octokit/octokit.rb/pulls/#{test_pr}/reviews/#{test_review}/comments")
      assert_requested :get, requested_url
    end
  end

  describe '.dismiss_pull_request_review' do
    it 'dismisses a request for change pull request review' do
      requested_url = github_url('/repos/octokit/octokit.rb/pulls/1/reviews/1/dismissals')
      stub_put requested_url

      @client.dismiss_pull_request_review('octokit/octokit.rb', 1, 1, 'I disagree!')

      assert_requested :put, requested_url
    end
  end

  context 'with pull request review' do
    describe '.update_pull_request_review' do
      it 'updates the review summary comment with new text' do
        requested_url = github_url('/repos/octokit/octokit.rb/pulls/1/reviews/1')
        stub_put requested_url

        @client.update_pull_request_review('octokit/octokit.rb', 1, 1, 'I disagree!')

        assert_requested :put, requested_url
      end
    end
  end

  context 'with repository', :vcr do
    before(:each) do
      @repo = @client.create_repository("test-repo-#{SecureRandom.hex(6)}", auto_init: true, organization: test_github_org)
    end

    after(:each) do
      @client.delete_repository(@repo.full_name)
    end

    context 'with pull request' do
      before(:each) do
        master_ref = @client.ref(@repo.full_name, 'heads/master')
        @client.create_ref(@repo.full_name, 'heads/branch-for-pr',
                           master_ref.object.sha)

        @content = @client.create_contents(@repo.full_name, 'lib/test.txt',
                                           'Adding content', 'File Content',
                                           branch: 'branch-for-pr')

        @pull = @client.create_pull_request(@repo.full_name, 'master',
                                            'branch-for-pr', 'A new PR',
                                            'The Body')
      end

      describe '.create_pull_request_review' do
        it 'creates a pull request review with comments' do
          comments = [{ path: 'lib/test.txt', position: 1, body: 'Good!' }]
          review = @client.create_pull_request_review(@repo.full_name,
                                                      @pull.number,
                                                      body: 'LGTM!',
                                                      comments: comments)

          expect(review.state).to eq('PENDING')

          requested_url = github_url("/repos/#{@repo.full_name}/pulls/#{@pull.number}/reviews")
          assert_requested :post, requested_url
        end
      end

      context 'with collaborator' do
        before do
          invitation = @client.invite_user_to_repository(@repo.full_name, test_github_collaborator_login)

          collaborator_client = Octokit::Client.new(access_token: test_github_collaborator_token)
          collaborator_client.accept_repository_invitation(invitation.id)

          @client.add_team_repository(test_github_team_id, @repo.full_name, permission: 'push')
        end

        describe '.pull_request_review_requests' do
          before do
            options = {
              reviewers: [test_github_collaborator_login],
              team_reviewers: [test_github_team_slug]
            }
            @client.request_pull_request_review(@repo.full_name, @pull.number, options)
          end
          after do
            options = {
              reviewers: [test_github_collaborator_login],
              team_reviewers: [test_github_team_slug]
            }
            @client.delete_pull_request_review_request(@repo.full_name, @pull.number, options)
          end

          it 'returns all requested reviewers' do
            reviewers = @client.pull_request_review_requests(@repo.full_name,
                                                             @pull.number)

            expect(reviewers.users).to be_kind_of Array
            expect(reviewers.users.size).to eq(1)
            expect(reviewers.teams).to be_kind_of Array
            expect(reviewers.teams.size).to eq(1)

            requested_url = github_url("/repos/#{@repo.full_name}/pulls/#{@pull.number}/requested_reviewers")
            assert_requested :get, requested_url
          end
        end

        describe '.request_pull_request_review' do
          after do
            options = {
              reviewers: [test_github_collaborator_login],
              team_reviewers: [test_github_team_slug]
            }
            @client.delete_pull_request_review_request(@repo.full_name, @pull.number, options)
          end

          it 'requests a new pull request review from a user' do
            options = {
              reviewers: [test_github_collaborator_login]
            }
            review_request = @client.request_pull_request_review(@repo.full_name, @pull.number, options)

            expect(review_request.requested_reviewers.length).to eq(1)
            expect(review_request.requested_teams.length).to eq(0)
            requested_url = github_url("/repos/#{@repo.full_name}/pulls/#{@pull.number}/requested_reviewers")
            assert_requested :post, requested_url
          end

          it 'requests a new pull request review from a team' do
            options = {
              team_reviewers: [test_github_team_slug]
            }
            review_request = @client.request_pull_request_review(@repo.full_name, @pull.number, options)

            expect(review_request.requested_reviewers.length).to eq(0)
            expect(review_request.requested_teams.length).to eq(1)
            requested_url = github_url("/repos/#{@repo.full_name}/pulls/#{@pull.number}/requested_reviewers")
            assert_requested :post, requested_url
          end
        end

        describe '.delete_pull_request_review_request' do
          before do
            options = {
              reviewers: [test_github_collaborator_login],
              team_reviewers: [test_github_team_slug]
            }
            @client.request_pull_request_review(@repo.full_name, @pull.number, options)
          end

          it 'deletes a requests for a pull request review from a user' do
            options = {
              reviewers: [test_github_collaborator_login]
            }
            review = @client.delete_pull_request_review_request(@repo.full_name, @pull.number, options)
            expect(review).to be_kind_of Sawyer::Resource

            requested_url = github_url("/repos/#{@repo.full_name}/pulls/#{@pull.number}/requested_reviewers")
            assert_requested :delete, requested_url
          end

          it 'deletes a requests for a pull request review from a team' do
            options = {
              reviewers: [],
              team_reviewers: [test_github_team_slug]
            }
            review = @client.delete_pull_request_review_request(@repo.full_name, @pull.number, options)
            expect(review).to be_kind_of Sawyer::Resource

            requested_url = github_url("/repos/#{@repo.full_name}/pulls/#{@pull.number}/requested_reviewers")
            assert_requested :delete, requested_url
          end
        end
      end

      context 'with pending pull request review' do
        before do
          @pending_review =
            @client.create_pull_request_review(@repo.full_name, @pull.number,
                                               body: 'LGTM!')
        end

        describe '.create_pull_request_review' do
          it 'creates a pull request review' do
            expect(@pending_review.body).to eq('LGTM!')

            requested_url = github_url("/repos/#{@repo.full_name}/pulls/#{@pull.number}/reviews")
            assert_requested :post, requested_url
          end
        end

        describe '.submit_pull_request_review' do
          it 'submits a pending pull request review' do
            review = @client.submit_pull_request_review(@repo.full_name,
                                                        @pull.number,
                                                        @pending_review.id,
                                                        'COMMENT')

            expect(review.body).to eq('LGTM!')
            expect(review.state).to eq('COMMENTED')

            requested_url = github_url("/repos/#{@repo.full_name}/pulls/#{@pull.number}/reviews/#{@pending_review.id}/events")
            assert_requested :post, requested_url
          end
        end

        describe '.delete_pull_request_review' do
          it 'deletes a pending pull request review' do
            review = @client.delete_pull_request_review(@repo.full_name,
                                                        @pull.number,
                                                        @pending_review.id)
            expect(review).to be_kind_of Sawyer::Resource

            requested_url = github_url("/repos/#{@repo.full_name}/pulls/#{@pull.number}/reviews/#{@pending_review.id}")
            assert_requested :delete, requested_url
          end
        end
      end
    end
  end
end

require 'helper'

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
    let(:test_review) { 6505518 }

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
    let(:test_review) { 6505518 }

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

  context 'with repository', :vcr do
    before(:each) do
      @repo = @client.create_repository('test-repo', auto_init: true)
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

      context 'with pull request review request' do
        before do
          reviewers = %w(coveralls hubot)
          reviewers.each do |reviewer|
            @client.add_collaborator(@repo.full_name, reviewer)
          end

          @review_request =
            @client.request_pull_request_review(@repo.full_name, @pull.number,
                                                reviewers)
        end

        describe '.request_pull_request_review' do
          it 'requests a new pull request review' do
            expect(@review_request.requested_reviewers.length).to eq(2)

            requested_url = github_url("/repos/#{@repo.full_name}/pulls/#{@pull.number}/requested_reviewers")
            assert_requested :post, requested_url
          end
        end

        describe '.pull_request_review_requests' do
          it 'returns all requested reviewers' do
            reviewers = @client.pull_request_review_requests(@repo.full_name,
                                                             @pull.number)
            expect(reviewers).to be_kind_of Array

            requested_url = github_url("/repos/#{@repo.full_name}/pulls/#{@pull.number}/requested_reviewers")
            assert_requested :get, requested_url
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

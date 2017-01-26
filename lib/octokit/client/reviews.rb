module Octokit
  class Client

    # Methods for the Reviews API
    #
    # @see https://developer.github.com/v3/reviews/
    module Reviews

      # List reviews on a pull request
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param id [Integer] The id of the pull request
      # @see https://developer.github.com/v3/pulls/reviews/#list-reviews-on-a-pull-request
      #
      # @example
      #   @client.pull_request_reviews('octokit/octokit.rb', 2)
      #
      # @return [Array<Sawyer::Resource>] Array of Hashes representing the reviews
      def pull_request_reviews(repo, id, options = {})
        options = ensure_api_media_type(:reviews, options)
        get "#{Repository.path repo}/pulls/#{id}/reviews", options
      end

      # Get a single review
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param pull_id [Integer] The id of the pull request
      # @param review_id [Integer] The id of the review
      # @see https://developer.github.com/v3/pulls/reviews/#get-a-single-review
      #
      # @example
      #   @client.pull_request_review('octokit/octokit.rb', 825, 6505518)
      #
      # @return [Sawyer::Resource] Hash representing the review
      def pull_request_review(repo, pull_id, review_id, options = {})
        options = ensure_api_media_type(:reviews, options)
        get "#{Repository.path repo}/pulls/#{pull_id}/reviews/#{review_id}", options
      end

      # Delete a pending review
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param pr_id [Integer] The id of the pull request
      # @param review_id [Integer] The id of the review
      # @see https://developer.github.com/v3/pulls/reviews/#delete-a-pending-review
      #
      # @example
      #   @client.delete_pull_request_review('octokit/octokit.rb', 825, 6505518)
      #
      # @return [Boolean] True if deleted, false otherwise
      def delete_pull_request_review(repo, pull_id, review_id, options = {})
        options = ensure_api_media_type(:reviews, options)
        boolean_from_response(
          :delete,
          "#{Repository.path repo}/pulls/#{pull_id}/reviews/#{review_id}",
          options
        )
      end

      # Get comments for a single review
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param pull_id [Integer] The id of the pull request
      # @param review_id [Integer] The id of the review
      # @see https://developer.github.com/v3/pulls/reviews/#get-comments-for-a-single-review
      #
      # @example
      #   @client.pull_request_review_comments('octokit/octokit.rb', 825, 6505518)
      #
      # @return [Array<Sawyer::Resource>] Array of Hashes representing the review comments
      def pull_request_review_comments(repo, pull_id, review_id, options = {})
        options = ensure_api_media_type(:reviews, options)
        get "#{Repository.path repo}/pulls/#{pull_id}/reviews/#{review_id}/comments",
            options
      end

      # Create a pull request review
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param id [Integer] The id of the pull request
      # @param options [Hash] Method options
      # @option options [String] :event The review action (event) to perform;
      #                                 can be one of APPROVE, REQUEST_CHANGES, or COMMENT.
      #                                 If left blank, the review is left PENDING.
      # @option options [String] :body The body text of the pull request review
      # @option options [Array<Hash>] :comments Comments part of the review
      # @option comments [String] :path The path to the file being commented on
      # @option comments [Integer] :position The position in the file to be commented on
      # @option comments [String] :body Body of the comment
      # @see https://developer.github.com/v3/pulls/reviews/#create-a-pull-request-review
      #
      # @example
      #   comments = [
      #     { path: '.travis.yml', position: 10, body: 'ruby-head is under development that is not stable.' },
      #     { path: '.travis.yml', position: 32, body: 'ruby-head is also required in thervm section.' },
      #   ]
      #   @client.create_pull_request_review('octokit/octokit.rb', 844,
      #                                      event: 'REQUEST_CHANGES',
      #                                      comments: comments)
      #
      # @return [Sawyer::Resource>] Hash respresenting the review
      def create_pull_request_review(repo, id, options = {})
        options = ensure_api_media_type(:reviews, options)
        post "#{Repository.path repo}/pulls/#{id}/reviews", options
      end

      # Submit a pull request review
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param pull_id [Integer] The id of the pull request
      # @param review_id [Integer] The id of the review
      # @param event [String] The review action (event) to perform; can be one of
      #                       APPROVE, REQUEST_CHANGES, or COMMENT.
      # @param options [Hash] Method options
      # @option options [String] :body The body text of the pull request review
      # @see https://developer.github.com/v3/pulls/reviews/#submit-a-pull-request-review
      #
      # @example
      #   @client.submit_pull_request_review('octokit/octokit.rb', 825, 6505518,
      #                                      'APPROVE', body: 'LGTM!')
      #
      # @return [Sawyer::Resource] Hash respresenting the review
      def submit_pull_request_review(repo, pull_id, review_id, event, options = {})
        options = ensure_api_media_type(:reviews, options)
        post "#{Repository.path repo}/pulls/#{pull_id}/reviews/#{review_id}/events",
             options.merge(event: event)
      end

      # Dismiss a pull request review
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param pull_id [Integer] The id of the pull request
      # @param review_id [Integer] The id of the review
      # @param message [String] The message for the pull request review dismissal
      # @see https://developer.github.com/v3/pulls/reviews/#dismiss-a-pull-request-review
      #
      # @example
      #   @client.dismiss_pull_request_review('octokit/octokit.rb', 825, 6505518)
      #
      # @return [Boolean] True if dismissed succesfully, otherwise false
      def dismiss_pull_request_review(repo, pull_id, review_id, message, options = {})
        options = ensure_api_media_type(:reviews, options)
        boolean_from_response(
          :put,
          "#{Repository.path repo}/pulls/#{pull_id}/reviews/#{review_id}/dismissals",
          options.merge(message: message)
        )
      end

      # List review requests
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param id [Integer] The id of the pull request
      # @see https://developer.github.com/v3/pulls/review_requests/#list-review-requests
      #
      # @example
      #   @client.pull_request_review_requests('octokit/octokit.rb', 2)
      #
      # @return [Array<Sawyer::Resource>] Array of Hashes representing the
      #                                   review requests
      def pull_request_review_requests(repo, id, options = {})
        options = ensure_api_media_type(:reviews, options)
        get "#{Repository.path repo}/pulls/#{id}/requested_reviewers", options
      end

      # Create a review request
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param id [Integer] The id of the pull request
      # @param reviewers [Array<String>] An array of user logins that will be requested
      # @see https://developer.github.com/v3/pulls/review_requests/#create-a-review-request
      #
      # @example
      #   @client.request_pull_request_review('octokit/octokit.rb', 2, ['soudy'])
      #
      # @return [Sawyer::Resource>] Hash respresenting the pull request
      def request_pull_request_review(repo, id, reviewers, options = {})
        options = ensure_api_media_type(:reviews, options)
        post "#{Repository.path repo}/pulls/#{id}/requested_reviewers",
             options.merge(reviewers: reviewers)
      end
    end
  end
end

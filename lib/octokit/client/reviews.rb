# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Reviews API
    #
    # @see https://developer.github.com/v3/pulls/reviews/
    module Reviews
      # Get a single review
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @param review_id [Integer] The ID of the review
      # @return [Sawyer::Resource] A single review
      # @see https://developer.github.com/v3/pulls/reviews/#get-a-single-review
      def pull_review(repo, pull_number, review_id, options = {})
        get "#{Repository.path repo}/pulls/#{pull_number}/reviews/#{review_id}", options
      end

      # List reviews on a pull request
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @return [Array<Sawyer::Resource>] A list of reviews
      # @see https://developer.github.com/v3/pulls/reviews/#list-reviews-on-a-pull-request
      def pull_reviews(repo, pull_number, options = {})
        paginate "#{Repository.path repo}/pulls/#{pull_number}/reviews", options
      end

      # Create a pull request review
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @option options [String] :commit_id The ID of the commit
      # @option options [String] :body Required when using REQUEST_CHANGES or COMMENT for the event parameter. The body text of the pull request review.
      # @option options [String] :event The review action you want to perform. The review actions include: APPROVE, REQUEST_CHANGES, or COMMENT. By leaving this blank, you set the review action state to PENDING, which means you will need to submit the pull request review (https://developer.github.com/v3/pulls/reviews/#submit-a-pull-request-review) when you are ready.
      # @option options [Array] :comments Use the following table to specify the location, destination, and contents of the draft review comment.
      # @return [Sawyer::Resource] The new review
      # @see https://developer.github.com/v3/pulls/reviews/#create-a-pull-request-review
      def create_pull_review(repo, pull_number, options = {})
        post "#{Repository.path repo}/pulls/#{pull_number}/reviews", options
      end

      # Update a pull request review
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @param review_id [Integer] The ID of the review
      # @param body [String] The body text of the pull request review.
      # @return [Sawyer::Resource] The updated pull
      # @see https://developer.github.com/v3/pulls/reviews/#update-a-pull-request-review
      def update_pull_review(repo, pull_number, review_id, body, options = {})
        opts = options.dup
        opts[:body] = body
        put "#{Repository.path repo}/pulls/#{pull_number}/reviews/#{review_id}", opts
      end

      # Delete a pending review
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @param review_id [Integer] The ID of the review
      # @return [Sawyer::Resource] The updated pull
      # @see https://developer.github.com/v3/pulls/reviews/#delete-a-pending-review
      def delete_pending_review(repo, pull_number, review_id, options = {})
        delete "#{Repository.path repo}/pulls/#{pull_number}/reviews/#{review_id}", options
      end

      # Get comments for a single review
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @param review_id [Integer] The ID of the review
      # @return [Array<Sawyer::Resource>] A list of comments
      # @see https://developer.github.com/v3/pulls/reviews/#get-comments-for-a-single-review
      def pull_review_comments(repo, pull_number, review_id, options = {})
        paginate "#{Repository.path repo}/pulls/#{pull_number}/reviews/#{review_id}/comments", options
      end

      # Submit a pull request review
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @param review_id [Integer] The ID of the review
      # @param event [String] The review action you want to perform. The review actions include: APPROVE, REQUEST_CHANGES, or COMMENT. When you leave this blank, the API returns HTTP 422 (Unrecognizable entity) and sets the review action state to PENDING, which means you will need to re-submit the pull request review using a review action.
      # @option options [String] :body The body text of the pull request review
      # @return [Sawyer::Resource] The new review
      # @see https://developer.github.com/v3/pulls/reviews/#submit-a-pull-request-review
      def submit_pull_review(repo, pull_number, review_id, event, options = {})
        opts = options.dup
        opts[:event] = event.to_s.downcase
        post "#{Repository.path repo}/pulls/#{pull_number}/reviews/#{review_id}/events", opts
      end

      # Dismiss a pull request review
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param pull_number [Integer] The number of the pull
      # @param review_id [Integer] The ID of the review
      # @param message [String] The message for the pull request review dismissal
      # @return [Sawyer::Resource] The updated pull
      # @see https://developer.github.com/v3/pulls/reviews/#dismiss-a-pull-request-review
      def dismiss_pull_review(repo, pull_number, review_id, message, options = {})
        opts = options.dup
        opts[:message] = message
        put "#{Repository.path repo}/pulls/#{pull_number}/reviews/#{review_id}/dismissals", opts
      end
    end
  end
end

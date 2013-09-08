module Octokit
  class Client

    # Methods for the Pull Requests API
    #
    # @see http://developer.github.com/v3/pulls/
    module PullRequests

      # List pull requests for a repository
      #
      # @see http://developer.github.com/v3/pulls/#list-pull-requests
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param options [Hash] Method options
      # @option options [String] :state `open` or `closed`. Default is `open`.
      # @return [Array<Sawyer::Resource>] Array of pulls
      # @example
      #   Octokit.pull_requests('rails/rails')
      def pull_requests(repo, state = nil, options = {})
        options[:state] = state if state
        get "repos/#{Repository.new(repo)}/pulls", options
      end
      alias :pulls :pull_requests

      # Get a pull request
      #
      # @see http://developer.github.com/v3/pulls/#get-a-single-pull-request
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Number of the pull request to fetch
      # @return [Sawyer::Resource] Pull request info
      def pull_request(repo, number, options = {})
        get "repos/#{Repository.new(repo)}/pulls/#{number}", options
      end
      alias :pull :pull_request

      # Create a pull request
      #
      # @see http://developer.github.com/v3/pulls/#create-a-pull-request
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param base [String] The branch (or git ref) you want your changes
      #                      pulled into. This should be an existing branch on the current
      #                      repository. You cannot submit a pull request to one repo that requests
      #                      a merge to a base of another repo.
      # @param head [String] The branch (or git ref) where your changes are implemented.
      # @param title [String] Title for the pull request
      # @param body [String] The body for the pull request. Supports GFM.
      # @return [Sawyer::Resource] The newly created pull request
      def create_pull_request(repo, base, head, title, body, options = {})
        pull = {
          :base  => base,
          :head  => head,
          :title => title,
          :body  => body,
        }
        post "repos/#{Repository.new(repo)}/pulls", options.merge(pull)
      end

      # Create a pull request from existing issue
      #
      # @see http://developer.github.com/v3/pulls/#alternative-input
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param base [String] The branch (or git ref) you want your changes
      #                      pulled into. This should be an existing branch on the current
      #                      repository. You cannot submit a pull request to one repo that requests
      #                      a merge to a base of another repo.
      # @param head [String] The branch (or git ref) where your changes are implemented.
      # @param issue [Integer] Number of Issue on which to base this pull request
      # @return [Sawyer::Resource] The newly created pull request
      def create_pull_request_for_issue(repo, base, head, issue, options = {})
        pull = {
          :base  => base,
          :head  => head,
          :issue => issue
        }
        post "repos/#{Repository.new(repo)}/pulls", options.merge(pull)
      end

      # Update a pull request
      # @overload update_pull_request(repo, id, title=nil, body=nil, state=nil, options = {})
      #   @deprecated
      #   @param repo [String, Hash, Repository] A GitHub repository.
      #   @param number [Integer] Number of pull request to update.
      #   @param title [String] Title for the pull request.
      #   @param body [String] Body content for pull request. Supports GFM.
      #   @param state [String] State of the pull request. `open` or `closed`.
      # @overload update_pull_request(repo, id,  options = {})
      #   @param repo [String, Hash, Repository] A GitHub repository.
      #   @param number [Integer] Number of pull request to update.
      #   @option options [String] :title Title for the pull request.
      #   @option options [String] :body Body for the pull request.
      #   @option options [String] :state State for the pull request.
      # @return [Sawyer::Resource] Hash representing updated pull request.
      # @see http://developer.github.com/v3/pulls/#update-a-pull-request
      # @example
      #   @client.update_pull_request('octokit/octokit.rb', 67, 'new title', 'updated body', 'closed')
      # @example Passing nil for optional attributes to update specific attributes.
      #   @client.update_pull_request('octokit/octokit.rb', 67, nil, nil, 'open')
      # @example Empty body by passing empty string
      #   @client.update_pull_request('octokit/octokit.rb', 67, nil, '')
      def update_pull_request(*args)
        arguments = Octokit::Arguments.new(args)
        repo   = arguments.shift
        number = arguments.shift
        title  = arguments.shift
        body   = arguments.shift
        state  = arguments.shift
        patch "repos/#{Repository.new repo}/pulls/#{number}", arguments.options
      end

      # Close a pull request
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param number [Integer] Number of pull request to update.
      # @return [Sawyer::Resource] Hash representing updated pull request.
      # @see http://developer.github.com/v3/pulls/#update-a-pull-request
      # @example
      #   @client.close_pull_request('octokit/octokit.rb', 67)
      def close_pull_request(repo, number, options = {})
        options.merge! :state => 'closed'
        update_pull_request(repo, number, options)
      end

      # List commits on a pull request
      #
      # @see http://developer.github.com/v3/pulls/#list-commits-on-a-pull-request
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Number of pull request
      # @return [Array<Sawyer::Resource>] List of commits
      def pull_request_commits(repo, number, options = {})
        get "repos/#{Repository.new(repo)}/pulls/#{number}/commits", options
      end
      alias :pull_commits :pull_request_commits

      # List pull request comments for a repository
      #
      # By default, Review Comments are ordered by ascending ID.
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param options [Hash] Optional parameters
      # @option options [String] :sort created or updated
      # @option options [String] :direction asc or desc. Ignored without sort
      #   parameter.
      # @option options [String] :since Timestamp in ISO 8601
      #   format: YYYY-MM-DDTHH:MM:SSZ
      #
      # @return [Array] List of pull request review comments.
      #
      # @see http://developer.github.com/v3/pulls/comments/#list-comments-in-a-repository
      #
      # @example Get the pull request review comments in the octokit repository
      #   @client.issues_comments("octokit/octokit.rb")
      #
      # @example Get review comments, sort by updated asc since a time
      #   @client.pull_requests_comments("octokit/octokit.rb", {
      #     :sort => 'asc',
      #     :direction => 'down',
      #     :since => '2010-05-04T23:45:02Z'
      #   })
      def pull_requests_comments(repo, options = {})
        get("repos/#{Repository.new repo}/pulls/comments", options)
      end
      alias :pulls_comments   :pull_requests_comments
      alias :reviews_comments :pull_requests_comments

      # List comments on a pull request
      #
      # @see http://developer.github.com/v3/pulls/#list-comments-on-a-pull-request
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Number of pull request
      # @return [Array<Sawyer::Resource>] List of comments
      def pull_request_comments(repo, number, options = {})
        # return the comments for a pull request
        get "repos/#{Repository.new(repo)}/pulls/#{number}/comments", options
      end
      alias :pull_comments   :pull_request_comments
      alias :review_comments :pull_request_comments

      # Get a pull request comment
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param comment_id [Integer] Id of comment to get
      # @return [Sawyer::Resource] Hash representing the comment
      # @see http://developer.github.com/v3/pulls/comments/#get-a-single-comment
      # @example
      #   @client.pull_request_comment("pengwynn/octkit", 1903950)
      def pull_request_comment(repo, comment_id, options = {})
        get "repos/#{Repository.new repo}/pulls/comments/#{comment_id}", options
      end
      alias :pull_comment   :pull_request_comment
      alias :review_comment :pull_request_comment

      # Create a pull request comment
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param pull_id [Integer] Pull request id
      # @param body [String] Comment content
      # @param commit_id [String] Sha of the commit to comment on.
      # @param path [String] Relative path of the file to comment on.
      # @param position [Integer] Line index in the diff to comment on.
      # @return [Sawyer::Resource] Hash representing the new comment
      # @see http://developer.github.com/v3/pulls/comments/#create-a-comment
      # @example
      #   @client.create_pull_request_comment("octokit/octokit.rb", 163, ":shipit:",
      #     "2d3201e4440903d8b04a5487842053ca4883e5f0", "lib/octokit/request.rb", 47)
      def create_pull_request_comment(repo, pull_id, body, commit_id, path, position, options = {})
        options.merge!({
          :body => body,
          :commit_id => commit_id,
          :path => path,
          :position => position
        })
        post "repos/#{Repository.new repo}/pulls/#{pull_id}/comments", options
      end
      alias :create_pull_comment :create_pull_request_comment
      alias :create_view_comment :create_pull_request_comment

      # Create reply to a pull request comment
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param pull_id [Integer] Pull request id
      # @param body [String] Comment contents
      # @param comment_id [Integer] Comment id to reply to
      # @return [Sawyer::Resource] Hash representing new comment
      # @see http://developer.github.com/v3/pulls/comments/#create-a-comment
      # @example
      #   @client.create_pull_request_comment_reply("octokit/octokit.rb", 1903950, "done.")
      def create_pull_request_comment_reply(repo, pull_id, body, comment_id, options = {})
        options.merge!({
          :body => body,
          :in_reply_to => comment_id
        })
        post "repos/#{Repository.new repo}/pulls/#{pull_id}/comments", options
      end
      alias :create_pull_reply   :create_pull_request_comment_reply
      alias :create_review_reply :create_pull_request_comment_reply

      # Update pull request comment
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param comment_id [Integer] Id of the comment to update
      # @param body [String] Updated comment content
      # @return [Sawyer::Resource] Hash representing the updated comment
      # @see http://developer.github.com/v3/pulls/comments/#edit-a-comment
      # @example
      #   @client.update_pull_request_comment("octokit/octokit.rb", 1903950, ":shipit:")
      def update_pull_request_comment(repo, comment_id, body, options = {})
        options.merge! :body => body
        patch("repos/#{Repository.new repo}/pulls/comments/#{comment_id}", options)
      end
      alias :update_pull_comment   :update_pull_request_comment
      alias :update_review_comment :update_pull_request_comment

      # Delete pull request comment
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param comment_id [Integer] Id of the comment to delete
      # @return [Boolean] True if deleted, false otherwise
      # @example
      #   @client.delete_pull_request_comment("octokit/octokit.rb", 1902707)
      def delete_pull_request_comment(repo, comment_id, options = {})
        boolean_from_response(:delete, "repos/#{Repository.new repo}/pulls/comments/#{comment_id}", options)
      end
      alias :delete_pull_comment   :delete_pull_request_comment
      alias :delete_review_comment :delete_pull_request_comment

      # List files on a pull request
      #
      # @see http://developer.github.com/v3/pulls/#list-files-on-a-pull-request
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Number of pull request
      # @return [Array<Sawyer::Resource>] List of files
      def pull_request_files(repo, number, options = {})
        get "repos/#{Repository.new(repo)}/pulls/#{number}/files", options
      end
      alias :pull_files :pull_request_files

      # Merge a pull request
      #
      # @see http://developer.github.com/v3/pulls/#merge-a-pull-request-merge-buttontrade
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Number of pull request
      # @param commit_message [String] Optional commit message for the merge commit
      # @return [Array<Sawyer::Resource>] Merge commit info if successful
      def merge_pull_request(repo, number, commit_message='', options = {})
        put "repos/#{Repository.new(repo)}/pulls/#{number}/merge", options.merge({:commit_message => commit_message})
      end

      # Check pull request merge status
      #
      # @see http://developer.github.com/v3/pulls/#get-if-a-pull-request-has-been-merged
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Number of pull request
      # @return [Boolean] True if the pull request has been merged
      def pull_merged?(repo, number, options = {})
        boolean_from_response :get, "repos/#{Repository.new(repo)}/pulls/#{number}/merge", options
      end
      alias :pull_request_merged? :pull_merged?

    end
  end
end

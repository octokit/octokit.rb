module Octokit
  class Client
    module Pulls
      # List pull requests for a repository
      #
      # @see http://developer.github.com/v3/pulls/#list-pull-requests
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param options [Hash] Method options
      # @option options [String] :state `open` or `closed`. Default is `open`.
      # @return [Array<Hashie::Mash>] Array of pulls
      # @example
      #   Octokit.pull_requests('rails/rails')
      def pull_requests(repo, state='open', options={})
        options.merge! :state => state
        repository(repo).rels[:pulls].get(:query => options).data
      end
      alias :pulls :pull_requests

      # Get a pull request
      #
      # @see http://developer.github.com/v3/pulls/#get-a-single-pull-request
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Number of the pull request to fetch
      # @return [Hashie::Mash] Pull request info
      def pull_request(repo, number, options={})
        options.merge! :uri => { :number => number }
        repository(repo).rels[:pulls].get(options).data
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
      # @return [Hashie::Mash] The newly created pull request
      def create_pull_request(repo, base, head, title, body, options={})
        pull = {
          :base  => base,
          :head  => head,
          :title => title,
          :body  => body,
        }
        repository(repo).rels[:pulls].post(options).data
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
      # @return [Hashie::Mash] The newly created pull request
      def create_pull_request_for_issue(repo, base, head, issue, options={})
        pull = {
          :base  => base,
          :head  => head,
          :issue => issue
        }
        options.merge! pull
        repository(repo).rels[:pulls].post(options).data
      end

      # Update a pull request
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param number [Integer] Number of pull request to update.
      # @param title [String] Title for the pull request.
      # @param body [String] Body content for pull request. Supports GFM.
      # @param state [String] State of the pull request. `open` or `closed`.
      # @return [Hashie::Mash] Hash representing updated pull request.
      # @see http://developer.github.com/v3/pulls/#update-a-pull-request
      # @example
      #   @client.update_pull_request('pengwynn/octokit', 67, 'new title', 'updated body', 'closed')
      # @example Passing nil for optional attributes to update specific attributes.
      #   @client.update_pull_request('pengwynn/octokit', 67, nil, nil, 'open')
      # @example Empty body by passing empty string
      #   @client.update_pull_request('pengwynn/octokit', 67, nil, '')
      def update_pull_request(repo, number, title=nil, body=nil, state=nil, options={})
        options.merge!({
          :title => title,
          :body => body,
          :state => state
        })
        uri_options = { :uri => { :number => number } }
        options.reject! { |_, value| value.nil? }
        repository(repo).rels[:pulls].put(options, uri_options).data
      end


      # List commits on a pull request
      #
      # @see http://developer.github.com/v3/pulls/#list-commits-on-a-pull-request
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Number of pull request
      # @return [Array<Hashie::Mash>] List of commits
      def pull_request_commits(repo, number, options={})
        pull_request(repo, number).rels[:commits].get(options).data
      end
      alias :pull_commits :pull_request_commits

      # List comments on a pull request
      #
      # @see http://developer.github.com/v3/pulls/#list-comments-on-a-pull-request
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Number of pull request
      # @return [Array<Hashie::Mash>] List of comments
      def pull_request_comments(repo, number, options={})
        options.merge! :uri => { :number => number }
        repository(repo).rels[:review_comments].get(options).data
      end
      alias :pull_comments   :pull_request_comments
      alias :review_comments :pull_request_comments

      # Get a pull request comment
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Id of comment to get
      # @return [Hashie::Mash] Hash representing the comment
      # @see http://developer.github.com/v3/pulls/comments/#get-a-single-comment
      # @example
      #   @client.pull_request_comment("pengwynn/octkit", 1903950)
      def pull_request_comment(repo, number, options={})
        options.merge! :uri => { :number => number }
        repository(repo).rels[:review_comment].get(options).data
      end
      alias :pull_comment   :pull_request_comment
      alias :review_comment :pull_request_comment

      # Create a pull request comment
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Pull request number
      # @param body [String] Comment content
      # @param commit_id [String] Sha of the commit to comment on.
      # @param path [String] Relative path of the file to comment on.
      # @param position [Integer] Line index in the diff to comment on.
      # @return [Hashie::Mash] Hash representing the new comment
      # @see http://developer.github.com/v3/pulls/comments/#create-a-comment
      # @example
      #   @client.create_pull_request_comment("pengwynn/octokit", 163, ":shipit:",
      #     "2d3201e4440903d8b04a5487842053ca4883e5f0", "lib/octokit/request.rb", 47)
      def create_pull_request_comment(repo, number, body, commit_id, path, position, options={})
        options.merge!({
          :body => body,
          :commit_id => commit_id,
          :path => path,
          :position => position
        })
        uri_options = {:uri => {:number => number } }
        repository(repo).rels[:review_comments].post(options, uri_options).data
      end
      alias :create_pull_comment :create_pull_request_comment
      alias :create_view_comment :create_pull_request_comment

      # Create reply to a pull request comment
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Pull number
      # @param body [String] Comment contents
      # @param comment_id [Integer] Comment id to reply to
      # @return [Hashie::Mash] Hash representing new comment
      # @see http://developer.github.com/v3/pulls/comments/#create-a-comment
      # @example
      #   @client.create_pull_request_comment_reply("pengwynn/octokit", 1903950, "done.")
      def create_pull_request_comment_reply(repo, number, body, comment_id, options={})
        options.merge!({
          :body => body,
          :in_reply_to => comment_id
        })
        pull_request(repo, number).rels[:review_comments].post(options).data
      end
      alias :create_pull_reply   :create_pull_request_comment_reply
      alias :create_review_reply :create_pull_request_comment_reply

      # Update pull request comment
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Id of the comment to update
      # @param body [String] Updated comment content
      # @return [Hashie::Mash] Hash representing the updated comment
      # @see http://developer.github.com/v3/pulls/comments/#edit-a-comment
      # @example
      #   @client.update_pull_request_comment("pengwynn/octokit", 1903950, ":shipit:")
      def update_pull_request_comment(repo, number, body, options={})
        options.merge! :body => body
        uri_options = {:uri => {:number => number }}
        repository(repo).rels[:review_comment].patch(options, uri_options).data
      end
      alias :update_pull_comment   :update_pull_request_comment
      alias :update_review_comment :update_pull_request_comment

      # Delete pull request comment
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] number of the comment to delete
      # @return [Boolean] True if deleted, false otherwise
      # @example
      #   @client.delete_pull_request_comment("pengwynn/octokit", 1902707)
      def delete_pull_request_comment(repo, number, options={})
        uri_options = {:uri => {:number => number }}
        repository(repo).rels[:review_comment].delete(options, uri_options).status == 204
      end
      alias :delete_pull_comment   :delete_pull_request_comment
      alias :delete_review_comment :delete_pull_request_comment

      # List files on a pull request
      #
      # @see http://developer.github.com/v3/pulls/#list-files-on-a-pull-request
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Number of pull request
      # @return [Array<Hashie::Mash>] List of files
      def pull_request_files(repo, number, options={})
        pull_request(repo, number).rels[:files].get(options).data
      end
      alias :pull_files :pull_request_files

      # Merge a pull request
      #
      # @see http://developer.github.com/v3/pulls/#merge-a-pull-request-merge-buttontrade
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Number of pull request
      # @param commit_message [String] Optional commit message for the merge commit
      # @return [Array<Hashie::Mash>] Merge commit info if successful
      def merge_pull_request(repo, number, commit_message='', options={})
        options.merge! :commit_message => commit_message
        pull_request(repo, number).rels[:merge].put(options).data
      end

      # Check pull request merge status
      #
      # @see http://developer.github.com/v3/pulls/#get-if-a-pull-request-has-been-merged
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Number of pull request
      # @return [Boolean] True if the pull request has been merged
      def pull_merged?(repo, number, options={})
        pull_request(repo, number).rels[:merge].get(options).status == 204
      end
      alias :pull_request_merged? :pull_merged?

    end
  end
end

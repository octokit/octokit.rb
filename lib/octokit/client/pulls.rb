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
        get("repos/#{Repository.new(repo)}/pulls", options.merge({:state => state}), 3)
      end
      alias :pulls :pull_requests

      # Get a pull request
      #
      # @see http://developer.github.com/v3/pulls/#get-a-single-pull-request
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Number of the pull request to fetch
      # @return [Hashie::Mash] Pull request info
      def pull_request(repo, number, options={})
        get("repos/#{Repository.new(repo)}/pulls/#{number}", options)
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
        post("repos/#{Repository.new(repo)}/pulls", options.merge(pull))
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
        post("repos/#{Repository.new(repo)}/pulls", options.merge(pull))
      end

      # Update a pull request
      #
      # @param repo [String, Hash, Repository] A GitHub repository.
      # @param id [Integer] Id of pull request to update.
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
      def update_pull_request(repo, id, title=nil, body=nil, state=nil, options={})
        options.merge!({
          :title => title,
          :body => body,
          :state => state
        })
        options.reject! { |_, value| value.nil? }
        post("repos/#{Repository.new repo}/pulls/#{id}", options, 3)
      end


      # List commits on a pull request
      #
      # @see http://developer.github.com/v3/pulls/#list-commits-on-a-pull-request
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Number of pull request
      # @return [Array<Hashie::Mash>] List of commits
      def pull_request_commits(repo, number, options={})
        get("repos/#{Repository.new(repo)}/pulls/#{number}/commits", options)
      end
      alias :pull_commits :pull_request_commits

      # List comments on a pull request
      #
      # @see http://developer.github.com/v3/pulls/#list-comments-on-a-pull-request
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Number of pull request
      # @return [Array<Hashie::Mash>] List of comments
      def pull_request_comments(repo, number, options={})
        # return the comments for a pull request
        get("repos/#{Repository.new(repo)}/pulls/#{number}/comments", options)
      end
      alias :pull_comments   :pull_request_comments
      alias :review_comments :pull_request_comments

      # List files on a pull request
      #
      # @see http://developer.github.com/v3/pulls/#list-files-on-a-pull-request
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Number of pull request
      # @return [Array<Hashie::Mash>] List of files
      def pull_request_files(repo, number, options={})
        get("repos/#{Repository.new(repo)}/pulls/#{number}/files", options)
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
        put("repos/#{Repository.new(repo)}/pulls/#{number}/merge", options.merge({:commit_message => commit_message}))
      end

      # Check pull request merge status
      #
      # @see http://developer.github.com/v3/pulls/#get-if-a-pull-request-has-been-merged
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param number [Integer] Number of pull request
      # @return [Boolean] True if the pull request has been merged
      def pull_merged?(repo, number, options={})
        begin
          get("repos/#{Repository.new(repo)}/pulls/#{number}/merged", options)
          return true
        rescue Octokit::NotFound
          return false
        end
      end
      alias :pull_request_merged? :pull_merged?

    end
  end
end

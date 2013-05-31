module Octokit
  class Client
    module Issues

      # Search issues within a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param search_term [String] The term to search for
      # @param state [String] :state (open) <tt>open</tt> or <tt>closed</tt>.
      # @return [Array] A list of issues matching the search term and state
      # @example Search for 'test' in the open issues for sferik/rails_admin
      #   Octokit.search_issues("sferik/rails_admin", 'test', 'open')
      def search_issues(repo, search_term, state='open', options={})
        get("legacy/issues/search/#{Repository.new(repo)}/#{state}/#{search_term}", options)['issues']
      end

      # List issues for a the authenticated user or repository
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :milestone Milestone number.
      # @option options [String] :state (open) State: <tt>open</tt> or <tt>closed</tt>.
      # @option options [String] :assignee User login.
      # @option options [String] :creator User login.
      # @option options [String] :mentioned User login.
      # @option options [String] :labels List of comma separated Label names. Example: <tt>bug,ui,@high</tt>.
      # @option options [String] :sort (created) Sort: <tt>created</tt>, <tt>updated</tt>, or <tt>comments</tt>.
      # @option options [String] :direction (desc) Direction: <tt>asc</tt> or <tt>desc</tt>.
      # @option options [Integer] :page (1) Page number.
      # @return [Array] A list of issues for a repository.
      # @see http://developer.github.com/v3/issues/#list-issues-for-this-repository
      # @example List issues for a repository
      #   Octokit.list_issues("sferik/rails_admin")
      # @example List issues for the authenticted user across repositories
      #   @client = Octokit::Client.new(:login => 'foo', :password => 'bar')
      #   @client.list_issues
      def list_issues(repository = nil, options={})
        path = ''
        path = "repos/#{Repository.new(repository)}" if repository
        path += "/issues"
        get(path, options)
      end
      alias :issues :list_issues

      # List all issues across owned and member repositories for the authenticated user
      #
      # @param options [Hash] A customizable set of options.
      # @option options [String] :filter (assigned) State: <tt>assigned</tt>, <tt>created</tt>, <tt>mentioned</tt>, <tt>subscribed</tt> or <tt>closed</tt>.
      # @option options [String] :state (open) State: <tt>open</tt> or <tt>all</tt>.
      # @option options [String] :labels List of comma separated Label names. Example: <tt>bug,ui,@high</tt>.
      # @option options [String] :sort (created) Sort: <tt>created</tt>, <tt>updated</tt>, or <tt>comments</tt>.
      # @option options [String] :direction (desc) Direction: <tt>asc</tt> or <tt>desc</tt>.
      # @option options [Integer] :page (1) Page number.
      # @option options [String] :since Timestamp in ISO 8601
      #   format: YYYY-MM-DDTHH:MM:SSZ
      # @return [Array] A list of issues for a repository.
      # @see http://developer.github.com/v3/issues/#list-issues
      # @example List issues for the authenticted user across owned and member repositories
      #   @client = Octokit::Client.new(:login => 'foo', :password => 'bar')
      #   @client.user_issues
      def user_issues(options={})
        get('/user/issues', options)
      end
      
      # List all issues for a given organization for the authenticated user
      #
      # @param org [String] Organization GitHub username.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :filter (assigned) State: <tt>assigned</tt>, <tt>created</tt>, <tt>mentioned</tt>, <tt>subscribed</tt> or <tt>closed</tt>.
      # @option options [String] :state (open) State: <tt>open</tt> or <tt>all</tt>.
      # @option options [String] :labels List of comma separated Label names. Example: <tt>bug,ui,@high</tt>.
      # @option options [String] :sort (created) Sort: <tt>created</tt>, <tt>updated</tt>, or <tt>comments</tt>.
      # @option options [String] :direction (desc) Direction: <tt>asc</tt> or <tt>desc</tt>.
      # @option options [Integer] :page (1) Page number.
      # @option options [String] :since Timestamp in ISO 8601
      #   format: YYYY-MM-DDTHH:MM:SSZ
      # @return [Array] A list of issues for a repository.
      # @see http://developer.github.com/v3/issues/#list-issues
      # @example List issues for the authenticted user across owned and member repositories
      #   @client = Octokit::Client.new(:login => 'foo', :password => 'bar')
      #   @client.user_issues
      def org_issues(org, options={})
        get("/orgs/#{org}/issues", options)
      end

      # Create an issue for a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param title [String] A descriptive title
      # @param body [String] A concise description
      # @param options [Hash] A customizable set of options.
      # @option options [String] :assignee User login.
      # @option options [Integer] :milestone Milestone number.
      # @option options [String] :labels List of comma separated Label names. Example: <tt>bug,ui,@high</tt>.
      # @return [Issue] Your newly created issue
      # @see http://developer.github.com/v3/issues/#create-an-issue
      # @example Create a new Issues for a repository
      #   Octokit.create_issue("sferik/rails_admin", 'Updated Docs', 'Added some extra links')
      def create_issue(repo, title, body, options={})
        post("repos/#{Repository.new(repo)}/issues", options.merge({:title => title, :body => body}))
      end
      alias :open_issue :create_issue

      # Get a single issue from a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [String] Number ID of the issue
      # @return [Issue] The issue you requested, if it exists
      # @see http://developer.github.com/v3/issues/#get-a-single-issue
      # @example Get issue #25 from pengwynn/octokit
      #   Octokit.issue("pengwynn/octokit", "25")
      def issue(repo, number, options={})
        get("repos/#{Repository.new(repo)}/issues/#{number}", options)
      end

      # Close an issue
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [String] Number ID of the issue
      # @param options [Hash] A customizable set of options.
      # @option options [String] :assignee User login.
      # @option options [Integer] :milestone Milestone number.
      # @option options [String] :labels List of comma separated Label names. Example: <tt>bug,ui,@high</tt>.
      # @return [Issue] The updated Issue
      # @see http://developer.github.com/v3/issues/#edit-an-issue
      # @example Close Issue #25 from pengwynn/octokit
      #   Octokit.close_issue("pengwynn/octokit", "25")
      def close_issue(repo, number, options={})
        patch("repos/#{Repository.new(repo)}/issues/#{number}", options.merge({:state => "closed"}))
      end

      # Reopen an issue
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [String] Number ID of the issue
      # @param options [Hash] A customizable set of options.
      # @option options [String] :assignee User login.
      # @option options [Integer] :milestone Milestone number.
      # @option options [String] :labels List of comma separated Label names. Example: <tt>bug,ui,@high</tt>.
      # @return [Issue] The updated Issue
      # @see http://developer.github.com/v3/issues/#edit-an-issue
      # @example Reopen Issue #25 from pengwynn/octokit
      #   Octokit.reopen_issue("pengwynn/octokit", "25")
      def reopen_issue(repo, number, options={})
        patch("repos/#{Repository.new(repo)}/issues/#{number}", options.merge({:state => "open"}))
      end

      # Update an issue
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [String] Number ID of the issue
      # @param title [String] Optional Updated title for the issue
      # @param body [String] Optional Updated body of the issue
      # @param options [Hash] A customizable set of options.
      # @option options [String] :assignee User login.
      # @option options [Integer] :milestone Milestone number.
      # @option options [String] :labels List of comma separated Label names. Example: <tt>bug,ui,@high</tt>.
      # @return [Issue] The updated Issue
      # @see http://developer.github.com/v3/issues/#edit-an-issue
      # @example Change the title of Issue #25
      #   Octokit.update_issue("pengwynn/octokit", "25", "A new title", "the same body"")
      def update_issue(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        repo    = args.shift
        number  = args.shift
        title   = args.shift
        body    = args.shift
        options[:title] = title unless title.nil?
        options[:body]  = body  unless body.nil?
        patch("repos/#{Repository.new(repo)}/issues/#{number}", options)
      end

      # Get all comments attached to issues for the repository
      #
      # By default, Issue Comments are ordered by ascending ID.
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param options [Hash] Optional parameters
      # @option options [String] :sort created or updated
      # @option options [String] :direction asc or desc. Ignored without sort
      #   parameter.
      # @option options [String] :since Timestamp in ISO 8601
      #   format: YYYY-MM-DDTHH:MM:SSZ
      #
      # @return [Array] List of issues comments.
      #
      # @see http://developer.github.com/v3/issues/comments/#list-comments-in-a-repository
      #
      # @example Get the comments for issues in the octokit repository
      #   @client.issues_comments("pengwynn/octokit")
      #
      # @example Get issues comments, sort by updated descending since a time
      #   @client.issues_comments("pengwynn/octokit", {
      #     :sort => 'desc',
      #     :direction => 'down',
      #     :since => '2010-05-04T23:45:02Z'
      #   })
      def issues_comments(repo, options={})
        get "/repos/#{Repository.new repo}/issues/comments", options
      end

      # Get all comments attached to an issue
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [String] Number ID of the issue
      # @return [Array] Array of comments that belong to an issue
      # @see http://developer.github.com/v3/issues/comments
      # @example Get comments for issue #25 from pengwynn/octokit
      #   Octokit.issue_comments("pengwynn/octokit", "25")
      def issue_comments(repo, number, options={})
        get("repos/#{Repository.new(repo)}/issues/#{number}/comments", options)
      end

      # Get a single comment attached to an issue
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [String] Number ID of the comment
      # @return [Comment] The specific comment in question
      # @see http://developer.github.com/v3/issues/comments/#get-a-single-comment
      # @example Get comment #1194549 from an issue on pengwynn/octokit
      #   Octokit.issue_comments("pengwynn/octokit", 1194549)
      def issue_comment(repo, number, options={})
        get("repos/#{Repository.new(repo)}/issues/comments/#{number}", options)
      end

      # Add a comment to an issue
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [Integer] Issue number
      # @param comment [String] Comment to be added
      # @return [Comment] A JSON encoded Comment
      # @see http://developer.github.com/v3/issues/comments/#create-a-comment
      # @example Add the comment "Almost to v1" to Issue #23 on pengwynn/octokit
      #   Octokit.add_comment("pengwynn/octokit", 23, "Almost to v1")
      def add_comment(repo, number, comment, options={})
        post("repos/#{Repository.new(repo)}/issues/#{number}/comments", options.merge({:body => comment}))
      end

      # Update a single comment on an issue
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [Integer] Comment number
      # @param comment [String] Body of the comment which will replace the existing body.
      # @return [Comment] A JSON encoded Comment
      # @see http://developer.github.com/v3/issues/comments/#edit-a-comment
      # @example Update the comment #1194549 with body "I've started this on my 25-issue-comments-v3 fork" on an issue on pengwynn/octokit
      #   Octokit.update_comment("pengwynn/octokit", 1194549, "Almost to v1, added this on my fork")
      def update_comment(repo, number, comment, options={})
        patch("repos/#{Repository.new(repo)}/issues/comments/#{number}", options.merge({:body => comment}))
      end

      # Delete a single comment
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [Integer] Comment number
      # @return [Boolean] Success
      # @see http://developer.github.com/v3/issues/comments/#delete-a-comment
      # @example Delete the comment #1194549 on an issue on pengwynn/octokit
      #   Octokit.delete_comment("pengwynn/octokit", 1194549)
      def delete_comment(repo, number, options={})
        boolean_from_response(:delete, "repos/#{Repository.new(repo)}/issues/comments/#{number}", options)
      end

      # List events for an Issue
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [Integer] Issue number
      #
      # @return [Array] Array of events for that issue
      # @see http://developer.github.com/v3/issues/events/#list-events-for-an-issue
      # @example List all issues events for issue #38 on pengwynn/octokit
      #   Octokit.issue_events("pengwynn/octokit", 38)
      def issue_events(repo, number, options={})
        get("repos/#{Repository.new(repo)}/issues/#{number}/events", options)
      end

      # Get information on a single Issue Event
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [Integer] Event number
      #
      # @return [Event] A single Event for an Issue
      # @see http://developer.github.com/v3/issues/events/#get-a-single-event
      # @example Get Event information for ID 3094334 (a pull request was closed)
      #   Octokit.issue_event("pengwynn/octokit", 3094334)
      def issue_event(repo, number, options={})
        get("repos/#{Repository.new(repo)}/issues/events/#{number}", options)
      end

    end
  end
end

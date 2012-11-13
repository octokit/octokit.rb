module Octokit
  class Client
    module Issues

      # Search issues within a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param search_term [String] The term to search for
      # @param state [String] :state (open) <tt>open</tt> or <tt>closed</tt>.
      # @return [Array] A list of issues matching the search term and state
      # @see http://develop.github.com/p/issues.html
      # @example Search for 'test' in the open issues for sferik/rails_admin
      #   Octokit.search_issues("sferik/rails_admin", 'test', 'open')
      def search_issues(repo, search_term, state='open', options={})
        repo = Repository.new(repo)
        options.merge! :uri => {
          :owner    => repo.owner,
          :repo     => repo.repo,
          :state    => state,
          :keyword  => search_term
        }
        root.rels[:issue_search].get(options).data.issues
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
      def list_issues(issues_repo = nil, options={})
        if issues_repo.nil?
          root.rels[:issues].get(options).data
        else
          repository(issues_repo).rels[:issues].get(options).data
        end
      end
      alias :issues :list_issues

      # Create an issue for a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param title [String] A descriptive title
      # @param body [String] A concise description
      # @return [Issue] Your newly created issue
      # @see http://develop.github.com/p/issues.html
      # @example Create a new Issues for a repository
      #   Octokit.create_issue("sferik/rails_admin")
      def create_issue(repo, title, body, options={})
        options.merge! :title => title, :body => body
        repository(repo).rels[:issues].post(options).data
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
        options.merge! :uri => { :number => number }
        repository(repo).rels[:issues].get(options).data
      end

      # Close an issue
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [String] Number ID of the issue
      # @return [Issue] The updated Issue
      # @see http://develop.github.com/p/issues.html
      # @note This implementation needs to be adjusted with switch to API v3
      # @see http://developer.github.com/v3/issues/#edit-an-issue
      # @example Close Issue #25 from pengwynn/octokit
      #   Octokit.close_issue("pengwynn/octokit", "25")
      def close_issue(repo, number, options={})
        options.merge! :state => "closed"
        uri_options = { :uri => { :number => number } }
        repository(repo).rels[:issues].post(options, uri_options).data
      end

      # Reopen an issue
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [String] Number ID of the issue
      # @return [Issue] The updated Issue
      # @see http://develop.github.com/p/issues.html
      # @note This implementation needs to be adjusted with switch to API v3
      # @see http://developer.github.com/v3/issues/#edit-an-issue
      # @example Reopen Issue #25 from pengwynn/octokit
      #   Octokit.reopen_issue("pengwynn/octokit", "25")
      def reopen_issue(repo, number, options={})
        options.merge! :state => "open"
        uri_options = { :uri => { :number => number } }
        repository(repo).rels[:issues].post(options, uri_options).data
      end

      # Update an issue
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [String] Number ID of the issue
      # @param title [String] Updated title for the issue
      # @param body [String] Updated body of the issue
      # @return [Issue] The updated Issue
      # @see http://develop.github.com/p/issues.html
      # @note This implementation needs to be adjusted with switch to API v3
      # @see http://developer.github.com/v3/issues/#edit-an-issue
      # @example Change the title of Issue #25
      #   Octokit.update_issue("pengwynn/octokit", "25", "A new title", "the same body"")
      def update_issue(repo, number, title, body, options={})
        options.merge! :title => title, :body => body
        uri_options = { :uri => { :number => number } }
        repository(repo).rels[:issues].patch(options, uri_options).data
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
        issue(repo, number).rels[:comments].get(options).data
      end

      # Get a single comment attached to an issue
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [String] Number ID of the issue
      # @return [Comment] The specific comment in question
      # @see http://developer.github.com/v3/issues/comments/#get-a-single-comment
      # @example Get comments for issue #25 from pengwynn/octokit
      #   Octokit.issue_comments("pengwynn/octokit", "25")
      def issue_comment(repo, number, options={})
        options.merge! :uri => {:number => number }
        repository(repo).rels[:issue_comment].get(options).data
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
        options.merge! :body => comment
        uri_options = { :uri => {:number => number } }
        issue(repo, number).rels[:comments].post(options, uri_options).data
      end

      # Update a single comment on an issue
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [Integer] Comment number
      # @param comment [String] Body of the comment which will replace the existing body.
      # @return [Comment] A JSON encoded Comment
      # @see http://developer.github.com/v3/issues/comments/#edit-a-comment
      # @example Update the comment "I've started this on my 25-issue-comments-v3 fork" on Issue #25 on pengwynn/octokit
      #   Octokit.update_comment("pengwynn/octokit", 25, "Almost to v1, added this on my fork")
      def update_comment(repo, number, comment, options={})
        options.merge! :body => comment
        uri_options = { :uri => {:number => number } }
        repository(repo).rels[:issue_comment].patch(options, uri_options).data
      end

      # Delete a single comment
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [Integer] Comment number
      # @return [Response] A response object with status
      # @see http://developer.github.com/v3/issues/comments/#delete-a-comment
      # @example Delete the comment "I've started this on my 25-issue-comments-v3 fork" on Issue #25 on pengwynn/octokit
      #   Octokit.delete_comment("pengwynn/octokit", 1194549)
      def delete_comment(repo, number, options={})
        uri_options = { :uri => {:number => number } }
        repository(repo).rels[:issue_comment].delete(options, uri_options).status == 204
      end


      # List events for an Issue
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param number [Integer] Issue number
      #
      # @return [Array] Array of events for that issue
      # @see http://developer.github.com/v3/issues/events/
      # @example List all issues events for issue #38 on pengwynn/octokit
      #   Octokit.issue_events("pengwynn/octokit", 38)
      def issue_events(repo, number, options={})
        issue(repo, number).rels[:events].get(options).data
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
        options.merge! :uri => {:number => number }
        repository(repo).rels[:issue_events].get(options).data
      end

    end
  end
end

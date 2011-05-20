module Octokit
  class Client
    module Issues

      # Search issues within a repository
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param search_term [String] The term to search for 
      # @param state [String] :state (open) <tt>open</tt> or <tt>closed</tt>.
      # @return [Array] A list of issues matching the search term and state
      # @see http://develop.github.com/p/issues.html
      # @example Search for 'test' in the open issues for sferik/rails_admin
      #   Octokit.search_issues("sferik/rails_admin", 'test', 'open')
      def search_issues(repo, search_term, state='open', options={})
        get("api/v2/json/issues/search/#{Repository.new(repo)}/#{state}/#{search_term}", options)['issues']
      end

      # List issues for a repository
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :milestone Milestone number.
      # @option options [String] :state (open) State: <tt>open</tt> or <tt>closed</tt>.
      # @option options [String] :assignee User login.
      # @option options [String] :mentioned User login.
      # @option options [String] :labels List of comma separated Label names. Example: <tt>bug,ui,@high</tt>.
      # @option options [String] :sort (created) Sort: <tt>created</tt>, <tt>updated</tt>, or <tt>comments</tt>.
      # @option options [String] :direction (desc) Direction: <tt>asc</tt> or <tt>desc</tt>.
      # @option options [Integer] :page (1) Page number.
      # @return [Array] A list of issues for a repository.
      # @see http://developer.github.com/v3/issues/#list-issues-for-this-repository
      # @example List issues for a repository
      #   Octokit.list_issues("sferik/rails_admin")
      def list_issues(repository, options={})
        get("/repos/#{Repository.new(repository)}/issues", options, 3)
      end
      alias :issues :list_issues
      
      # Create an issue for a repository
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param title [String] A descriptive title
      # @param body [String] A concise description
      # @return [Issue] Your newly created issue
      # @see http://develop.github.com/p/issues.html
      # @example Create a new Issues for a repository
      #   Octokit.create_issue("sferik/rails_admin")
      def create_issue(repo, title, body, options={})
        post("api/v2/json/issues/open/#{Repository.new(repo)}", options.merge({:title => title, :body => body}))['issue']
      end
      alias :open_issue :create_issue
      
      # Get a single issue from a repository
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param number [String] Number ID of the issue
      # @return [Issue] The issue you requested, if it exists
      # @see http://developer.github.com/v3/issues/#get-a-single-issue
      # @example Get issue #25 from pengwynn/octokit
      #   Octokit.issue("pengwynn/octokit", "25")
      def issue(repo, number, options={})
        get("api/v2/json/issues/show/#{Repository.new(repo)}/#{number}", options)['issue']
      end

      # Close an issue
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param number [String] Number ID of the issue
      # @return [Issue] The updated Issue
      # @see http://develop.github.com/p/issues.html
      # @note This implementation needs to be adjusted with switch to API v3
      # @see http://developer.github.com/v3/issues/#edit-an-issue 
      # @example Close Issue #25 from pengwynn/octokit
      #   Octokit.close_issue("pengwynn/octokit", "25")
      def close_issue(repo, number, options={})
        post("api/v2/json/issues/close/#{Repository.new(repo)}/#{number}", options)['issue']
      end

      # Reopen an issue
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param number [String] Number ID of the issue
      # @return [Issue] The updated Issue
      # @see http://develop.github.com/p/issues.html
      # @note This implementation needs to be adjusted with switch to API v3
      # @see http://developer.github.com/v3/issues/#edit-an-issue 
      # @example Reopen Issue #25 from pengwynn/octokit
      #   Octokit.reopen_issue("pengwynn/octokit", "25")
      def reopen_issue(repo, number, options={})
        post("api/v2/json/issues/reopen/#{Repository.new(repo)}/#{number}", options)['issue']
      end

      # Update an issue
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
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
        post("api/v2/json/issues/edit/#{Repository.new(repo)}/#{number}", options.merge({:title => title, :body => body}))['issue']
      end

      # List available labels for a repository
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @return [Array] A list of the labels currently on the issue
      # @see http://develop.github.com/p/issues.html
      # @see http://developer.github.com/v3/issues/labels/
      # @example List labels for pengwynn/octokit
      #   Octokit.labels("pengwynn/octokit")
      def labels(repo, options={})
        get("api/v2/json/issues/labels/#{Repository.new(repo)}", options)['labels']
      end
      
      # Add a label to a repository
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param label [String] A new label 
      # @param number [Integer] Optional Issue number to associate with the label
      # @return [Array] A list of the labels currently on the issue
      # @see http://develop.github.com/p/issues.html
      # @see http://developer.github.com/v3/issues/labels/
      # @example Add a new label and add it to Issue #11
      #   Octokit.add_label("pengwynn/octokit", "Version 1.0", "11")
      def add_label(repo, label, number=nil, options={})
        post(["api/v2/json/issues/label/add/#{Repository.new(repo)}/#{label}", number].compact.join('/'), options)['labels']
      end

      # Remove a label from a repository
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param label [String] Label you wish to remove
      # @param number [Integer] Optional Issue number to remove the label from
      # @note Leaving the number parameter out will remove this label from all issues
      # @return [Array] A list of the labels currently on the issue
      # @see http://develop.github.com/p/issues.html
      # @see http://developer.github.com/v3/issues/labels/
      # @example Remove the label "Version 1.0" from the repository
      #   Octokit.remove_label("pengwynn/octokit", "Version 1.0")
      def remove_label(repo, label, number=nil, options={})
        post(["api/v2/json/issues/label/remove/#{Repository.new(repo)}/#{label}", number].compact.join('/'), options)['labels']
      end
      
      # Get all comments attached to an issue
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param number [String] Number ID of the issue
      # @return [Array] Array of comments that belong to an issue
      # @see http://develop.github.com/p/issues.html
      # @example Get comments for issue #25 from pengwynn/octokit
      #   Octokit.issue_comments("pengwynn/octokit", "25")
      def issue_comments(repo, number, options={})
        get("repos/#{Repository.new(repo)}/issues/#{number}/comments", options, 3)
      end

      # Get a single comment attached to an issue
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param number [String] Number ID of the issue
      # @return [Array] Array of comments that belong to an issue
      # @see http://develop.github.com/p/issues.html
      # @example Get comments for issue #25 from pengwynn/octokit
      #   Octokit.issue_comments("pengwynn/octokit", "25")
      def issue_comment(repo, number, options={})
        get("repos/#{Repository.new(repo)}/issues/comments/#{number}", options, 3)
      end

      # Add a comment to an issue
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param number [Integer] Issue number 
      # @param comment [String] Comment to be added
      # @return [Comment] A JSON encoded Comment 
      # @see http://develop.github.com/p/issues.html
      # @see http://developer.github.com/v3/issues/labels/
      # @example Add the comment "Almost to v1" to Issue #23 on pengwynn/octokit
      #   Octokit.add_comment("pengwynn/octokit", 23, "Almost to v1")
      def add_comment(repo, number, comment, options={})
        post("repos/#{Repository.new(repo)}/issues/#{number}/comments", options.merge({:body => comment}), 3)
      end
    end
  end
end



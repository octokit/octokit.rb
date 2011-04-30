module Octokit
  class Client
    module Issues

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
      #   Octokit.list_isses("sferik/rails_admin")
      def list_issues(repository, options={})
        get("/repos/#{Repository.new(repository)}/issues", options, 3)
      end
      alias :issues :list_issues

      def create_issue(repo, title, body, options={})
        post("api/v2/json/issues/open/#{Repository.new(repo)}", options.merge({:title => title, :body => body}))['issue']
      end
      alias :open_issue :create_issue

      def issue(repo, number, options={})
        get("api/v2/json/issues/show/#{Repository.new(repo)}/#{number}", options)['issue']
      end

      def issue_comments(repo, number, options={})
        get("api/v2/json/issues/comments/#{Repository.new(repo)}/#{number}", options)['comments']
      end

      def close_issue(repo, number, options={})
        post("api/v2/json/issues/close/#{Repository.new(repo)}/#{number}", options)['issue']
      end

      def reopen_issue(repo, number, options={})
        post("api/v2/json/issues/reopen/#{Repository.new(repo)}/#{number}", options)['issue']
      end

      def update_issue(repo, number, title, body, options={})
        post("api/v2/json/issues/edit/#{Repository.new(repo)}/#{number}", options.merge({:title => title, :body => body}))['issue']
      end

      def labels(repo, options={})
        get("api/v2/json/issues/labels/#{Repository.new(repo)}", options)['labels']
      end

      def add_label(repo, label, number=nil, options={})
        post(["api/v2/json/issues/label/add/#{Repository.new(repo)}/#{label}", number].compact.join('/'), options)['labels']
      end

      def remove_label(repo, label, number=nil, options={})
        post(["api/v2/json/issues/label/remove/#{Repository.new(repo)}/#{label}", number].compact.join('/'), options)['labels']
      end

      def add_comment(repo, number, comment, options={})
        post("api/v2/json/issues/comment/#{Repository.new(repo)}/#{number}", options.merge({:comment => comment}))['comment']
      end
    end
  end
end

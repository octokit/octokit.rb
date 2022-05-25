# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Issues API
    #
    # @see https://developer.github.com/v3/issues/
    module Issues
      # List issues assigned to the authenticated user
      #
      # @option options [String] :filter Indicates which sorts of issues to return. Can be one of:   assigned, created, mentioned, subscribed, all
      # @option options [String] :state Indicates the state of the issues to return. Can be either open, closed, or all.
      # @option options [String] :labels A list of comma separated label names. Example: bug,ui,@high
      # @option options [String] :sort What to sort results by. Can be either created, updated, comments.
      # @option options [String] :direction The direction of the sort. Can be either asc or desc.
      # @option options [String] :since Only issues updated at or after this time are returned. This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ.
      # @return [Array<Sawyer::Resource>] A list of issues
      # @see https://developer.github.com/v3/issues/#list-issues-assigned-to-the-authenticated-user
      def issues(options = {})
        paginate 'issues', options
      end

      # List user account issues assigned to the authenticated user
      #
      # @option options [String] :filter Indicates which sorts of issues to return. Can be one of:   assigned, created, mentioned, subscribed, all
      # @option options [String] :state Indicates the state of the issues to return. Can be either open, closed, or all.
      # @option options [String] :labels A list of comma separated label names. Example: bug,ui,@high
      # @option options [String] :sort What to sort results by. Can be either created, updated, comments.
      # @option options [String] :direction The direction of the sort. Can be either asc or desc.
      # @option options [String] :since Only issues updated at or after this time are returned. This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ.
      # @return [Array<Sawyer::Resource>] A list of issues
      # @see https://developer.github.com/v3/issues/#list-user-account-issues-assigned-to-the-authenticated-user
      def user_issues(options = {})
        paginate 'user/issues', options
      end

      # List organization issues assigned to the authenticated user
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @option options [String] :filter Indicates which sorts of issues to return. Can be one of:   assigned, created, mentioned, subscribed, all
      # @option options [String] :state Indicates the state of the issues to return. Can be either open, closed, or all.
      # @option options [String] :labels A list of comma separated label names. Example: bug,ui,@high
      # @option options [String] :sort What to sort results by. Can be either created, updated, comments.
      # @option options [String] :direction The direction of the sort. Can be either asc or desc.
      # @option options [String] :since Only issues updated at or after this time are returned. This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ.
      # @return [Array<Sawyer::Resource>] A list of issues
      # @see https://developer.github.com/v3/issues/#list-organization-issues-assigned-to-the-authenticated-user
      def org_issues(org, options = {})
        paginate "#{Organization.path org}/issues", options
      end

      # List repository issues
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [String] :milestone If an integer is passed, it should refer to a milestone by its number field. If the string  is passed, issues with any milestone are accepted. If the string none is passed, issues without milestones are returned.
      # @option options [String] :state Indicates the state of the issues to return. Can be either open, closed, or all.
      # @option options [String] :assignee Can be the name of a user. Pass in none for issues with no assigned user, and  for issues assigned to any user.
      # @option options [String] :creator The user that created the issue.
      # @option options [String] :mentioned A user that's mentioned in the issue.
      # @option options [String] :labels A list of comma separated label names. Example: bug,ui,@high
      # @option options [String] :sort What to sort results by. Can be either created, updated, comments.
      # @option options [String] :direction The direction of the sort. Can be either asc or desc.
      # @option options [String] :since Only issues updated at or after this time are returned. This is a timestamp in ISO 8601 (https://en.wikipedia.org/wiki/ISO_8601) format: YYYY-MM-DDTHH:MM:SSZ.
      # @return [Array<Sawyer::Resource>] A list of issues
      # @see https://developer.github.com/v3/issues/#list-repository-issues
      def repo_issues(repo, options = {})
        paginate "#{Repository.path repo}/issues", options
      end

      # Create an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param title [String] The title of the issue.
      # @option options [String] :body The contents of the issue.
      # @option options [String] :assignee Login for the user that this issue should be assigned to. NOTE: Only users with push access can set the assignee for new issues. The assignee is silently dropped otherwise. This field is deprecated.
      # @option options [Integer] :milestone The number of the milestone to associate this issue with. NOTE: Only users with push access can set the milestone for new issues. The milestone is silently dropped otherwise.
      # @option options [Array] :labels Labels to associate with this issue. NOTE: Only users with push access can set labels for new issues. Labels are silently dropped otherwise.
      # @option options [Array] :assignees Logins for Users to assign to this issue. NOTE: Only users with push access can set assignees for new issues. Assignees are silently dropped otherwise.
      # @return [Sawyer::Resource] The new issue
      # @see https://developer.github.com/v3/issues/#create-an-issue
      def create_issue(repo, title, options = {})
        opts = options.dup
        opts[:title] = title
        post "#{Repository.path repo}/issues", opts
      end

      # Get an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @return [Sawyer::Resource] A single issue
      # @see https://developer.github.com/v3/issues/#get-an-issue
      def issue(repo, issue_number, options = {})
        get "#{Repository.path repo}/issues/#{issue_number}", options
      end

      # Update an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @option options [String] :title The title of the issue.
      # @option options [String] :body The contents of the issue.
      # @option options [String] :assignee Login for the user that this issue should be assigned to. This field is deprecated.
      # @option options [String] :state State of the issue. Either open or closed.
      # @option options [Integer] :milestone The number of the milestone to associate this issue with or null to remove current. NOTE: Only users with push access can set the milestone for issues. The milestone is silently dropped otherwise.
      # @option options [Array] :labels Labels to associate with this issue. Pass one or more Labels to replace the set of Labels on this Issue. Send an empty array ([]) to clear all Labels from the Issue. NOTE: Only users with push access can set labels for issues. Labels are silently dropped otherwise.
      # @option options [Array] :assignees Logins for Users to assign to this issue. Pass one or more user logins to replace the set of assignees on this Issue. Send an empty array ([]) to clear all assignees from the Issue. NOTE: Only users with push access can set assignees for new issues. Assignees are silently dropped otherwise.
      # @return [Sawyer::Resource] The updated issue
      # @see https://developer.github.com/v3/issues/#update-an-issue
      def update_issue(repo, issue_number, options = {})
        patch "#{Repository.path repo}/issues/#{issue_number}", options
      end

      # Reopen an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @option options [String] :title The title of the issue.
      # @option options [String] :body The contents of the issue.
      # @option options [String] :assignee Login for the user that this issue should be assigned to. This field is deprecated.
      # @option options [Integer] :milestone The number of the milestone to associate this issue with or null to remove current. NOTE: Only users with push access can set the milestone for issues. The milestone is silently dropped otherwise.
      # @option options [Array] :labels Labels to associate with this issue. Pass one or more Labels to replace the set of Labels on this Issue. Send an empty array ([]) to clear all Labels from the Issue. NOTE: Only users with push access can set labels for issues. Labels are silently dropped otherwise.
      # @option options [Array] :assignees Logins for Users to assign to this issue. Pass one or more user logins to replace the set of assignees on this Issue. Send an empty array ([]) to clear all assignees from the Issue. NOTE: Only users with push access can set assignees for new issues. Assignees are silently dropped otherwise.
      def reopen_issue(repo, issue_number, options = {})
        options[:state] = 'open'
        patch "#{Repository.path repo}/issues/#{issue_number}", options
      end

      # Close an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @option options [String] :title The title of the issue.
      # @option options [String] :body The contents of the issue.
      # @option options [String] :assignee Login for the user that this issue should be assigned to. This field is deprecated.
      # @option options [Integer] :milestone The number of the milestone to associate this issue with or null to remove current. NOTE: Only users with push access can set the milestone for issues. The milestone is silently dropped otherwise.
      # @option options [Array] :labels Labels to associate with this issue. Pass one or more Labels to replace the set of Labels on this Issue. Send an empty array ([]) to clear all Labels from the Issue. NOTE: Only users with push access can set labels for issues. Labels are silently dropped otherwise.
      # @option options [Array] :assignees Logins for Users to assign to this issue. Pass one or more user logins to replace the set of assignees on this Issue. Send an empty array ([]) to clear all assignees from the Issue. NOTE: Only users with push access can set assignees for new issues. Assignees are silently dropped otherwise.
      def close_issue(repo, issue_number, options = {})
        options[:state] = 'closed'
        patch "#{Repository.path repo}/issues/#{issue_number}", options
      end

      # Lock an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @option options [String] :lock_reason The reason for locking the issue or pull request conversation. Lock will fail if you don't use one of these reasons:   off-topic  , too heated  , resolved  , spam
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/issues/#lock-an-issue
      def lock_issue(repo, issue_number, options = {})
        boolean_from_response :put, "#{Repository.path repo}/issues/#{issue_number}/lock", options
      end

      # Unlock an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/issues/#unlock-an-issue
      def unlock_issue(repo, issue_number, options = {})
        boolean_from_response :delete, "#{Repository.path repo}/issues/#{issue_number}/lock", options
      end
    end
  end
end

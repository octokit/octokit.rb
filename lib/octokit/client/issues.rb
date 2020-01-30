module Octokit
  class Client
    # Methods for the Issues API
    #
    # @see https://developer.github.com/v3/issues/
    module Issues

      # List all issues assigned to the authenticated user across all visible repositories including owned repositories, member repositories, and organization repositories
      #
      # @option options [String] :filter Indicates which sorts of issues to return. Can be one of:  assigned, created, mentioned, subscribed, all
      # @option options [String] :state Indicates the state of the issues to return. Can be either `open`, `closed`, or `all`.
      # @option options [String] :labels A list of comma separated label names. Example: `bug,ui,@high`
      # @option options [String] :sort What to sort results by. Can be either `created`, `updated`, `comments`.
      # @option options [String] :direction The direction of the sort. Can be either `asc` or `desc`.
      # @option options [String] :since Only issues updated at or after this time are returned. This is a timestamp in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format: `YYYY-MM-DDTHH:MM:SSZ`.
      # @return [Array<Sawyer::Resource>] A list of issues
      # @see https://developer.github.com/v3/issues/#list-issues
      def issues(options = {})
        paginate "issues", options
      end

      # List all issues for a given organization assigned to the authenticated user
      #
      # @param org [Integer, String] A GitHub organization id or login
      # @option options [String] :filter Indicates which sorts of issues to return. Can be one of:  assigned, created, mentioned, subscribed, all
      # @option options [String] :state Indicates the state of the issues to return. Can be either `open`, `closed`, or `all`.
      # @option options [String] :labels A list of comma separated label names. Example: `bug,ui,@high`
      # @option options [String] :sort What to sort results by. Can be either `created`, `updated`, `comments`.
      # @option options [String] :direction The direction of the sort. Can be either `asc` or `desc`.
      # @option options [String] :since Only issues updated at or after this time are returned. This is a timestamp in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format: `YYYY-MM-DDTHH:MM:SSZ`.
      # @return [Array<Sawyer::Resource>] A list of issues
      # @see https://developer.github.com/v3/issues/#list-issues
      def org_issues(org, options = {})
        paginate "#{Organization.path org}/issues", options
      end

      # List issues for a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [String] :milestone If an `integer` is passed, it should refer to a milestone by its `number` field. If the string `*` is passed, issues with any milestone are accepted. If the string `none` is passed, issues without milestones are returned.
      # @option options [String] :state Indicates the state of the issues to return. Can be either `open`, `closed`, or `all`.
      # @option options [String] :assignee Can be the name of a user. Pass in `none` for issues with no assigned user, and `*` for issues assigned to any user.
      # @option options [String] :creator The user that created the issue.
      # @option options [String] :mentioned A user that's mentioned in the issue.
      # @option options [String] :labels A list of comma separated label names. Example: `bug,ui,@high`
      # @option options [String] :sort What to sort results by. Can be either `created`, `updated`, `comments`.
      # @option options [String] :direction The direction of the sort. Can be either `asc` or `desc`.
      # @option options [String] :since Only issues updated at or after this time are returned. This is a timestamp in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format: `YYYY-MM-DDTHH:MM:SSZ`.
      # @return [Array<Sawyer::Resource>] A list of issues
      # @see https://developer.github.com/v3/issues/#list-issues-for-a-repository
      def repository_issues(repo, options = {})
        paginate "#{Repository.path repo}/issues", options
      end

      # Create an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param title [String] The title of the issue.
      # @option options [String] :body The contents of the issue.
      # @option options [String] :assignee Login for the user that this issue should be assigned to. _NOTE: Only users with push access can set the assignee for new issues. The assignee is silently dropped otherwise. **This field is deprecated.**_
      # @option options [Integer] :milestone The `number` of the milestone to associate this issue with. _NOTE: Only users with push access can set the milestone for new issues. The milestone is silently dropped otherwise._
      # @option options [Array] :labels Labels to associate with this issue. _NOTE: Only users with push access can set labels for new issues. Labels are silently dropped otherwise._
      # @option options [Array] :assignees Logins for Users to assign to this issue. _NOTE: Only users with push access can set assignees for new issues. Assignees are silently dropped otherwise._
      # @return [Sawyer::Resource] The new issue
      # @see https://developer.github.com/v3/issues/#create-an-issue
      def create_issue(repo, title, options = {})
        options[:title] = title
        post "#{Repository.path repo}/issues", options
      end

      # Get a single issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @return [Sawyer::Resource] A single issue
      # @see https://developer.github.com/v3/issues/#get-a-single-issue
      def issue(repo, issue_number, options = {})
        get "#{Repository.path repo}/issues/#{issue_number}", options
      end

      # Get a single comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @return [Sawyer::Resource] A list of comments
      # @see https://developer.github.com/v3/issues/comments/#get-a-single-comment
      def issue_comment(repo, comment_id, options = {})
        paginate "#{Repository.path repo}/issues/comments/#{comment_id}", options
      end

      # Get a single event
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param event_id [Integer] The ID of the event
      # @return [Sawyer::Resource] A single event
      # @see https://developer.github.com/v3/issues/events/#get-a-single-event
      def issue_event(repo, event_id, options = {})
        get "#{Repository.path repo}/issues/events/#{event_id}", options
      end

      # List comments in a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [String] :sort Either `created` or `updated`.
      # @option options [String] :direction Either `asc` or `desc`. Ignored without the `sort` parameter.
      # @option options [String] :since Only comments updated at or after this time are returned. This is a timestamp in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format: `YYYY-MM-DDTHH:MM:SSZ`.
      # @return [Array<Sawyer::Resource>] A list of comments
      # @see https://developer.github.com/v3/issues/comments/#list-comments-in-a-repository
      def repository_comments(repo, options = {})
        get "#{Repository.path repo}/issues/comments", options
      end

      # List events for a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/issues/events/#list-events-for-a-repository
      def repository_events(repo, options = {})
        paginate "#{Repository.path repo}/issues/events", options
      end

      # Edit an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @option options [String] :title The title of the issue.
      # @option options [String] :body The contents of the issue.
      # @option options [String] :assignee Login for the user that this issue should be assigned to. **This field is deprecated.**
      # @option options [String] :state State of the issue. Either `open` or `closed`.
      # @option options [Integer] :milestone The `number` of the milestone to associate this issue with or `null` to remove current. _NOTE: Only users with push access can set the milestone for issues. The milestone is silently dropped otherwise._
      # @option options [Array] :labels Labels to associate with this issue. Pass one or more Labels to _replace_ the set of Labels on this Issue. Send an empty array (`[]`) to clear all Labels from the Issue. _NOTE: Only users with push access can set labels for issues. Labels are silently dropped otherwise._
      # @option options [Array] :assignees Logins for Users to assign to this issue. Pass one or more user logins to _replace_ the set of assignees on this Issue. Send an empty array (`[]`) to clear all assignees from the Issue. _NOTE: Only users with push access can set assignees for new issues. Assignees are silently dropped otherwise._
      # @return [Sawyer::Resource] The updated issue
      # @see https://developer.github.com/v3/issues/#edit-an-issue
      def update_issue(repo, issue_number, options = {})
        patch "#{Repository.path repo}/issues/#{issue_number}", options
      end

     # Reopen an issue
     #
     # @param repo [Integer, String, Repository, Hash] A GitHub repository
     # @param issue_number [Integer] The number of the issue
     # @option options [String] :title The title of the issue.
     # @option options [String] :body The contents of the issue.
     # @option options [String] :assignee Login for the user that this issue should be assigned to. **This field is deprecated.**
     # @option options [Integer] :milestone The `number` of the milestone to associate this issue with or `null` to remove current. _NOTE: Only users with push access can set the milestone for issues. The milestone is silently dropped otherwise._
     # @option options [Array] :labels Labels to associate with this issue. Pass one or more Labels to _replace_ the set of Labels on this Issue. Send an empty array (`[]`) to clear all Labels from the Issue. _NOTE: Only users with push access can set labels for issues. Labels are silently dropped otherwise._
     # @option options [Array] :assignees Logins for Users to assign to this issue. Pass one or more user logins to _replace_ the set of assignees on this Issue. Send an empty array (`[]`) to clear all assignees from the Issue. _NOTE: Only users with push access can set assignees for new issues. Assignees are silently dropped otherwise._
     def reopen_issue(repo, issue_number, options = {})
        options[:state] = "open"
        patch "#{Repository.path repo}/issues/#{issue_number}", options
      end

     # Close an issue
     #
     # @param repo [Integer, String, Repository, Hash] A GitHub repository
     # @param issue_number [Integer] The number of the issue
     # @option options [String] :title The title of the issue.
     # @option options [String] :body The contents of the issue.
     # @option options [String] :assignee Login for the user that this issue should be assigned to. **This field is deprecated.**
     # @option options [Integer] :milestone The `number` of the milestone to associate this issue with or `null` to remove current. _NOTE: Only users with push access can set the milestone for issues. The milestone is silently dropped otherwise._
     # @option options [Array] :labels Labels to associate with this issue. Pass one or more Labels to _replace_ the set of Labels on this Issue. Send an empty array (`[]`) to clear all Labels from the Issue. _NOTE: Only users with push access can set labels for issues. Labels are silently dropped otherwise._
     # @option options [Array] :assignees Logins for Users to assign to this issue. Pass one or more user logins to _replace_ the set of assignees on this Issue. Send an empty array (`[]`) to clear all assignees from the Issue. _NOTE: Only users with push access can set assignees for new issues. Assignees are silently dropped otherwise._
     def close_issue(repo, issue_number, options = {})
        options[:state] = "closed"
        patch "#{Repository.path repo}/issues/#{issue_number}", options
      end

      # Edit a comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @param body [String] The contents of the comment.
      # @return [Sawyer::Resource] The updated comment
      # @see https://developer.github.com/v3/issues/comments/#edit-a-comment
      def update_issue_comment(repo, comment_id, body, options = {})
        options[:body] = body
        patch "#{Repository.path repo}/issues/comments/#{comment_id}", options
      end

      # Delete a comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/issues/comments/#delete-a-comment
      def delete_issue_comment(repo, comment_id, options = {})
        boolean_from_response :delete, "#{Repository.path repo}/issues/comments/#{comment_id}", options
      end

      # List events for an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/issues/timeline/#list-events-for-an-issue
      def timeline_events(repo, issue_number, options = {})
        opts = options
        opts[:accept] = "application/vnd.github.mockingbird-preview+json" if opts[:accept].nil?

        paginate "#{Repository.path repo}/issues/#{issue_number}/timeline", opts
      end

      # List reactions for an issue comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @option options [String] :content Returns a single [reaction type](https://developer.github.com/v3/reactions/#reaction-types). Omit this parameter to list all reactions to an issue comment.
      # @return [Array<Sawyer::Resource>] A list of reactions
      # @see https://developer.github.com/v3/reactions/#list-reactions-for-an-issue-comment
      def issue_comment_reactions(repo, comment_id, options = {})
        opts = options
        opts[:accept] = "application/vnd.github.squirrel-girl-preview+json" if opts[:accept].nil?

        paginate "#{Repository.path repo}/issues/comments/#{comment_id}/reactions", opts
      end

      # List comments on an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @option options [String] :since Only comments updated at or after this time are returned. This is a timestamp in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format: `YYYY-MM-DDTHH:MM:SSZ`.
      # @return [Array<Sawyer::Resource>] A list of comments
      # @see https://developer.github.com/v3/issues/comments/#list-comments-on-an-issue
      def issue_comments(repo, issue_number, options = {})
        paginate "#{Repository.path repo}/issues/#{issue_number}/comments", options
      end

      # List events for an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/issues/events/#list-events-for-an-issue
      def issue_events(repo, issue_number, options = {})
        paginate "#{Repository.path repo}/issues/#{issue_number}/events", options
      end

      # List labels on an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @return [Array<Sawyer::Resource>] A list of labels
      # @see https://developer.github.com/v3/issues/labels/#list-labels-on-an-issue
      def issue_labels(repo, issue_number, options = {})
        paginate "#{Repository.path repo}/issues/#{issue_number}/labels", options
      end

      # List reactions for an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @option options [String] :content Returns a single [reaction type](https://developer.github.com/v3/reactions/#reaction-types). Omit this parameter to list all reactions to an issue.
      # @return [Array<Sawyer::Resource>] A list of reactions
      # @see https://developer.github.com/v3/reactions/#list-reactions-for-an-issue
      def issue_reactions(repo, issue_number, options = {})
        opts = options
        opts[:accept] = "application/vnd.github.squirrel-girl-preview+json" if opts[:accept].nil?

        paginate "#{Repository.path repo}/issues/#{issue_number}/reactions", opts
      end

      # Create reaction for an issue comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param comment_id [Integer] The ID of the comment
      # @param content [String] The [reaction type](https://developer.github.com/v3/reactions/#reaction-types) to add to the issue comment.
      # @return [Sawyer::Resource] The new reaction
      # @see https://developer.github.com/v3/reactions/#create-reaction-for-an-issue-comment
      def create_issue_comment_reaction(repo, comment_id, content, options = {})
        options[:content] = content.to_s.downcase
        opts = options
        opts[:accept] = "application/vnd.github.squirrel-girl-preview+json" if opts[:accept].nil?

        post "#{Repository.path repo}/issues/comments/#{comment_id}/reactions", opts
      end

      # Create reaction for an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @param content [String] The [reaction type](https://developer.github.com/v3/reactions/#reaction-types) to add to the issue.
      # @return [Sawyer::Resource] The new reaction
      # @see https://developer.github.com/v3/reactions/#create-reaction-for-an-issue
      def create_issue_reaction(repo, issue_number, content, options = {})
        options[:content] = content.to_s.downcase
        opts = options
        opts[:accept] = "application/vnd.github.squirrel-girl-preview+json" if opts[:accept].nil?

        post "#{Repository.path repo}/issues/#{issue_number}/reactions", opts
      end

      # Add assignees to an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @option options [Array] :assignees Usernames of people to assign this issue to. _NOTE: Only users with push access can add assignees to an issue. Assignees are silently ignored otherwise._
      # @return [Sawyer::Resource] The updated issue
      # @see https://developer.github.com/v3/issues/assignees/#add-assignees-to-an-issue
      def add_issue_assignees(repo, issue_number, options = {})
        post "#{Repository.path repo}/issues/#{issue_number}/assignees", options
      end

      # Create a comment
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @param body [String] The contents of the comment.
      # @return [Sawyer::Resource] The new comment
      # @see https://developer.github.com/v3/issues/comments/#create-a-comment
      def create_issue_comment(repo, issue_number, body, options = {})
        options[:body] = body
        post "#{Repository.path repo}/issues/#{issue_number}/comments", options
      end

      # Add labels to an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @param labels [Array] The name of the label to add to the issue. Must contain at least one label. **Note:** Alternatively, you can pass a single label as a `string` or an `array` of labels directly, but GitHub recommends passing an object with the `labels` key.
      # @return [Sawyer::Resource] The new label
      # @see https://developer.github.com/v3/issues/labels/#add-labels-to-an-issue
      def add_issue_labels(repo, issue_number, labels, options = {})
        options[:labels] = labels
        post "#{Repository.path repo}/issues/#{issue_number}/labels", options
      end

      # Lock an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @option options [String] :lock_reason The reason for locking the issue or pull request conversation. Lock will fail if you don't use one of these reasons:  off-topic, too heated, resolved, spam
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/issues/#lock-an-issue
      def lock_issue(repo, issue_number, options = {})
        boolean_from_response :put, "#{Repository.path repo}/issues/#{issue_number}/lock", options
      end

      # Replace all labels for an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @option options [Array] :labels The names of the labels to add to the issue. You can pass an empty array to remove all labels. **Note:** Alternatively, you can pass a single label as a `string` or an `array` of labels directly, but GitHub recommends passing an object with the `labels` key.
      # @return [Sawyer::Resource] An array of the remaining labels
      # @see https://developer.github.com/v3/issues/labels/#replace-all-labels-for-an-issue
      def replace_issue_labels(repo, issue_number, options = {})
        put "#{Repository.path repo}/issues/#{issue_number}/labels", options
      end

      # Remove all labels from an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/issues/labels/#remove-all-labels-from-an-issue
      def remove_issue_labels(repo, issue_number, options = {})
        boolean_from_response :delete, "#{Repository.path repo}/issues/#{issue_number}/labels", options
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

      # Remove assignees from an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @option options [Array] :assignees Usernames of assignees to remove from an issue. _NOTE: Only users with push access can remove assignees from an issue. Assignees are silently ignored otherwise._
      # @return [Sawyer::Resource] The updated issue
      # @see https://developer.github.com/v3/issues/assignees/#remove-assignees-from-an-issue
      def remove_issue_assignees(repo, issue_number, options = {})
        delete "#{Repository.path repo}/issues/#{issue_number}/assignees", options
      end

      # Remove a label from an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @param name [String] The name of the label
      # @return [Sawyer::Resource] An array of the remaining label
      # @see https://developer.github.com/v3/issues/labels/#remove-a-label-from-an-issue
      def remove_issue_label(repo, issue_number, name, options = {})
        delete "#{Repository.path repo}/issues/#{issue_number}/labels/#{name}", options
      end
    end
  end
end

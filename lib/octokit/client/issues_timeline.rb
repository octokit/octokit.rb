# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the IssuesTimeline API
    #
    # @see https://developer.github.com/v3/issues/timeline/
    module IssuesTimeline
      # List timeline events for an issue
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param issue_number [Integer] The number of the issue
      # @return [Array<Sawyer::Resource>] A list of events
      # @see https://developer.github.com/v3/issues/timeline/#list-timeline-events-for-an-issue
      def timeline_events(repo, issue_number, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.mockingbird-preview+json' if opts[:accept].nil?

        paginate "#{Repository.path repo}/issues/#{issue_number}/timeline", opts
      end
    end
  end
end

# frozen_string_literal: true

module Octokit
  # GitHub team class to generate API path urls
  class Team
    # Get the api path for a team
    #
    # @param org [String, Integer] GitHub organization login or id
    # @param team [String, Integer] Team slug or id
    # @return [String] Team Api path
    # @example Name-based path
    #   Octokit::Team.path('github', 'justice-league')
    #   # => "orgs/github/teams/justice-league"
    # @example ID-based path
    #   Octokit::Team.path(3430433, 123456)
    #   # => "organizations/3430433/team/123456"
    def self.path(org, team)
      case org
      when String
        "orgs/#{org}/teams/#{team}"
      when Integer
        "organizations/#{org}/team/#{team}"
      else
        raise ArgumentError, "Organization must be a String (login) or Integer (id)"
      end
    end
  end
end

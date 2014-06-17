module Octokit
  # GitHub organization class to generate API path urls
  class Organization
    # Get the api path for an organization
    #
    # @param org [String, Integer] GitHub organization login or id
    # @return [String] Organization Api path
    def self.path org
      return "orgs/#{org}" if org.is_a? String
      return "organizations/#{org}" if org.is_a? Integer
    end
  end
end

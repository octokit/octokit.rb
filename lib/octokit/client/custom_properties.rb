# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Repository Custom Properties API
    #
    # @see https://docs.github.com/en/rest/repos/custom-properties
    module CustomProperties
      # Get all custom property values for a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] List of custom property values
      # @see https://docs.github.com/en/rest/repos/custom-properties#get-all-custom-property-values-for-a-repository
      def get_repo_custom_properties(repo, options = {})
        get("#{Repository.path repo}/properties/values", options)
      end

      # Create or update custom property values for a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param properties [Array<Hash>] List of custom property names and associated values
      # @option properties [String] :property_name The name of the property
      # @option properties [String, Array<String>, nil] :value The value of the property
      # @return [Boolean] True on success
      # @see https://docs.github.com/en/rest/repos/custom-properties#create-or-update-custom-property-values-for-a-repository
      def update_repo_custom_properties(repo, properties, options = {})
        options[:properties] = properties
        patch("#{Repository.path repo}/properties/values", options)
      end
    end
  end
end

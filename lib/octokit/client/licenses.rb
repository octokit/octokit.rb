# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the Licenses API
    #
    # @see https://developer.github.com/v3/licenses/
    module Licenses
      # List commonly used licenses
      #
      #
      # @return [Array<Sawyer::Resource>] A list of licenses
      # @see https://developer.github.com/v3/licenses/#list-commonly-used-licenses
      def commonly_used(options = {})
        get 'licenses', options
      end

      # Get an individual license
      #
      # @param license [String] The license of the license
      # @return [Sawyer::Resource] A single license
      # @see https://developer.github.com/v3/licenses/#get-an-individual-license
      def license(license, options = {})
        get "licenses/#{license}", options
      end

      # Get the contents of a repository's license
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Sawyer::Resource] A single license
      # @see https://developer.github.com/v3/licenses/#get-the-contents-of-a-repositorys-license
      def repo_license(repo, options = {})
        get "#{Repository.path repo}/license", options
      end
    end
  end
end

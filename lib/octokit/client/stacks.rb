# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the pull request stacks API
    #
    # @see https://developer.github.com/v3/pulls/stacks
    module Stacks
      # List pull request stacks for a repository
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param options [Hash] Method options
      # @option options [Integer] :pull_request filter to the stack containing this pull request
      #                           number ID
      # @see https://developer.github.com/v3/pulls/stacks/#list-pull-request-stacks
      #
      # @example
      #   Octokit.pull_request_stacks('rails/rails', :pull_request => 1234)
      #
      # @return [Array<Sawyer::Resource>] Array of stacks
      def pull_request_stacks(repo, options = {})
        paginate "#{Repository.path repo}/stacks", options
      end
      alias stacks pull_request_stacks

      # Get a pull request stack
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param stack_number [Integer] Number of the stack to fetch
      # @see https://developer.github.com/v3/pulls/stacks/#get-a-pull-request-stack
      #
      # @example
      #   Octokit.pull_request_stack('rails/rails', 123)
      #
      # @return [Sawyer::Resource] The stack
      def pull_request_stack(repo, stack_number, options = {})
        get "#{Repository.path repo}/stacks/#{stack_number}", options
      end
      alias stack pull_request_stack

      # Create a pull request stack
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param options [Hash] Method options
      # @option options [Array<Integer>] :pull_requests An ordered list of number IDs of the pull
      #                                  requests forming the stack, bottom to top
      # @see https://developer.github.com/v3/pulls/stacks/#create-a-pull-request-stack
      #
      # @example
      #   options = { pull_requests: [123, 124, 127] }
      #   @client.create_pull_request_stack('rails/rails', options)
      #
      # @return [Sawyer::Resource] The newly created stack
      def create_pull_request_stack(repo, options = {})
        post "#{Repository.path repo}/stacks", options
      end

      # Add pull requests to a pull request stack
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param stack_number [Integer] Number of the stack to modify
      # @param options [Hash] Method options
      # @option options [Array<Integer>] :pull_requests An ordered list of number IDs of the pull
      #                                  requests to append to the stack, from the current
      #                                  top upward
      # @see https://developer.github.com/v3/pulls/stacks/#add-pull-requests-to-a-pull-request-stack
      #
      # @example
      #   options = { pull_requests: [129, 131] }
      #   @client.add_pull_requests_to_stack('rails/rails', 111, options)
      #
      # @return [Sawyer::Resource] The stack
      def add_pull_requests_to_stack(repo, stack_number, options = {})
        post "#{Repository.path repo}/stacks/#{stack_number}/add", options
      end

      # Remove unmerged pull requests from a pull request stack
      #
      # @param repo [Integer, String, Hash, Repository] A GitHub repository
      # @param stack_number [Integer] Number of the stack to modify
      # @param options [Hash] Method options
      # @see https://developer.github.com/v3/pulls/stacks/#remove-pull-requests-from-a-pull-request-stack
      #
      # @example
      #   @client.remove_pull_requests_from_stack('rails/rails', 111)
      #
      # @return [Boolean] True if the unmerged pull requests were removed
      def remove_pull_requests_from_stack(repo, stack_number, options = {})
        post "#{Repository.path repo}/stacks/#{stack_number}/unstack", options

        [200, 204].include? last_response.status
      end
    end
  end
end

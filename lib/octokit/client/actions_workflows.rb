module Octokit
  class Client
    # Methods for the Actions Workflows API
    #
    # @see https://developer.github.com/v3/actions/workflows
    module ActionsWorkflows

      # Get the workflows in a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      #
      # @return [Sawyer::Resource] the total count and an array of workflows
      # @see https://developer.github.com/v3/actions/workflows/#list-repository-workflows
      def workflows(repo, options = {})
        paginate "#{Repository.path repo}/actions/workflows", options
      end
      alias list_workflows workflows

      # Get single workflow in a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param id [Integer, String] Id or file name of the workflow
      #
      # @return [Sawyer::Resource] A single workflow
      # @see https://developer.github.com/v3/actions/workflows/#get-a-workflow
      def workflow(repo, id, options = {})
        get "#{Repository.path repo}/actions/workflows/#{id}", options
      end
    end
  end
end

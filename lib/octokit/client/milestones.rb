module Octokit
  class Client

    # Methods for the Issues Milestones API
    #
    # @see http://developer.github.com/v3/issues/milestones/
    module Milestones

      # List milestones for a repository
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :milestone Milestone number.
      # @option options [String] :state (open) State: <tt>open</tt> or <tt>closed</tt>.
      # @option options [String] :sort (created) Sort: <tt>created</tt>, <tt>updated</tt>, or <tt>comments</tt>.
      # @option options [String] :direction (desc) Direction: <tt>asc</tt> or <tt>desc</tt>.
      # @return [Array<Sawyer::Resource>] A list of milestones for a repository.
      # @see http://developer.github.com/v3/issues/milestones/#List-Milestones-for-an-Issue
      # @example List milestones for a repository
      #   Octokit.list_milestones("octokit/octokit.rb")
      def list_milestones(repository, options = {})
        paginate "repos/#{Repository.new(repository)}/milestones", options
      end
      alias :milestones :list_milestones

      # Get a single milestone for a repository
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :milestone Milestone number.
      # @option options [String] :state (open) State: <tt>open</tt> or <tt>closed</tt>.
      # @option options [String] :sort (created) Sort: <tt>created</tt>, <tt>updated</tt>, or <tt>comments</tt>.
      # @option options [String] :direction (desc) Direction: <tt>asc</tt> or <tt>desc</tt>.
      # @return [Sawyer::Resource] A single milestone from a repository.
      # @see http://developer.github.com/v3/issues/milestones/#get-a-single-milestone
      # @example Get a single milestone for a repository
      #   Octokit.milestone("octokit/octokit.rb", 1)
      def milestone(repository, number, options = {})
        get "repos/#{Repository.new(repository)}/milestones/#{number}", options
      end

      # Create a milestone for a repository
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param title [String] A unique title.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :state (open) State: <tt>open</tt> or <tt>closed</tt>.
      # @option options [String] :description A meaningful description
      # @option options [Time] :due_on Set if the milestone has a due date
      # @return [Sawyer::Resource] A single milestone object
      # @see http://developer.github.com/v3/issues/milestones/#create-a-milestone
      # @example Create a milestone for a repository
      #   Octokit.create_milestone("octokit/octokit.rb", "0.7.0", {:description => 'Add support for v3 of Github API'})
      def create_milestone(repository, title, options = {})
        post "repos/#{Repository.new(repository)}/milestones", options.merge({:title => title})
      end

      # Update a milestone for a repository
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param number [String, Integer] ID of the milestone
      # @param options [Hash] A customizable set of options.
      # @option options [String] :title A unique title.
      # @option options [String] :state (open) State: <tt>open</tt> or <tt>closed</tt>.
      # @option options [String] :description A meaningful description
      # @option options [Time] :due_on Set if the milestone has a due date
      # @return [Sawyer::Resource] A single milestone object
      # @see http://developer.github.com/v3/issues/milestones/#update-a-milestone
      # @example Update a milestone for a repository
      #   Octokit.update_milestone("octokit/octokit.rb", 1, {:description => 'Add support for v3 of Github API'})
      def update_milestone(repository, number, options = {})
        patch "repos/#{Repository.new(repository)}/milestones/#{number}", options
      end
      alias :edit_milestone :update_milestone

      # Delete a single milestone for a repository
      #
      # @param repository [String, Repository, Hash] A GitHub repository.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :milestone Milestone number.
      # @return [Boolean] Success
      # @see http://developer.github.com/v3/issues/milestones/#delete-a-milestone
      # @example Delete a single milestone from a repository
      #   Octokit.delete_milestone("octokit/octokit.rb", 1)
      def delete_milestone(repository, number, options = {})
        boolean_from_response :delete, "repos/#{Repository.new(repository)}/milestones/#{number}", options
      end
    end
  end
end

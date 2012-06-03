module Octokit
  class Client
    module Refs

      # List all refs for a given user and repo
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param namespace [String] The ref namespace, e.g. <tt>tag</tt> or <tt>heads</tt>
      # @return [Array] A list of references matching the repo and the namespace
      # @see http://developer.github.com/v3/git/refs/
      # @example Fetch all refs for sferik/rails_admin
      #   Octokit.refs("sferik/rails_admin")
      def refs(repo, namespace="", options={})
        get("/repos/#{Repository.new(repo)}/git/refs/#{namespace}", options, 3)
      end
      alias :list_refs :refs
      alias :references :refs
      alias :list_references :refs

    end
  end
end

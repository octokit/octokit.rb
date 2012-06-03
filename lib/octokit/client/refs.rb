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

      # Fetch a given reference
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param ref [String] The ref, e.g. <tt>tags/v0.0.3</tt>
      # @return [Reference] The reference matching the given repo and the ref id
      # @see http://developer.github.com/v3/git/refs/
      # @example Fetch refs/tags/v0.0.3 for sferik/rails_admin
      #   Octokit.ref("sferik/rails_admin","tags/v0.0.3")
      def ref(repo, ref, options={})
        get("/repos/#{Repository.new(repo)}/git/refs/#{ref}", options, 3)
      end
      alias :reference :ref

    end
  end
end

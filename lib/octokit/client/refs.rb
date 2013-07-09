module Octokit
  class Client

    # Methods for References for Git Data API
    #
    # @see http://developer.github.com/v3/git/refs/
    module Refs

      # List all refs for a given user and repo
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param namespace [String] The ref namespace, e.g. <tt>tag</tt> or <tt>heads</tt>
      # @return [Array<Sawyer::Resource>] A list of references matching the repo and the namespace
      # @see http://developer.github.com/v3/git/refs/
      # @example Fetch all refs for sferik/rails_admin
      #   Octokit.refs("sferik/rails_admin")
      def refs(repo, namespace = nil, options = {})
        path = "repos/#{Repository.new(repo)}/git/refs"
        path += "/#{namespace}" unless namespace.nil?
        get path, options
      end
      alias :list_refs :refs
      alias :references :refs
      alias :list_references :refs

      # Fetch a given reference
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param ref [String] The ref, e.g. <tt>tags/v0.0.3</tt>
      # @return [Sawyer::Resource] The reference matching the given repo and the ref id
      # @see http://developer.github.com/v3/git/refs/
      # @example Fetch tags/v0.0.3 for sferik/rails_admin
      #   Octokit.ref("sferik/rails_admin","tags/v0.0.3")
      def ref(repo, ref, options = {})
        get "repos/#{Repository.new(repo)}/git/refs/#{ref}", options
      end
      alias :reference :ref

      # Create a reference
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param ref [String] The ref, e.g. <tt>tags/v0.0.3</tt>
      # @param sha [String] A SHA, e.g. <tt>827efc6d56897b048c772eb4087f854f46256132</tt>
      # @return [Array<Sawyer::Resource>] The list of references, already containing the new one
      # @see http://developer.github.com/v3/git/refs/
      # @example Create refs/heads/master for octocat/Hello-World with sha 827efc6d56897b048c772eb4087f854f46256132
      #   Octokit.create_ref("octocat/Hello-World","heads/master", "827efc6d56897b048c772eb4087f854f46256132")
      def create_ref(repo, ref, sha, options = {})
        parameters = {
          :ref  => "refs/#{ref}",
          :sha  => sha
        }
        post "repos/#{Repository.new(repo)}/git/refs", options.merge(parameters)
      end
      alias :create_reference :create_ref

      # Update a reference
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param ref [String] The ref, e.g. <tt>tags/v0.0.3</tt>
      # @param sha [String] A SHA, e.g. <tt>827efc6d56897b048c772eb4087f854f46256132</tt>
      # @param force [Boolean] A flag indicating one wants to force the update to make sure the update is a fast-forward update.
      # @return [Array<Sawyer::Resource>] The list of references updated
      # @see http://developer.github.com/v3/git/refs/
      # @example Force update heads/sc/featureA for octocat/Hello-World with sha aa218f56b14c9653891f9e74264a383fa43fefbd
      #   Octokit.update_ref("octocat/Hello-World","heads/sc/featureA", "aa218f56b14c9653891f9e74264a383fa43fefbd")
      def update_ref(repo, ref, sha, force = true, options = {})
        parameters = {
          :sha  => sha,
          :force => force
        }
        patch "repos/#{Repository.new(repo)}/git/refs/#{ref}", options.merge(parameters)
      end
      alias :update_reference :update_ref

      # Delete a single reference
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param ref [String] The ref, e.g. <tt>tags/v0.0.3</tt>
      # @return [Boolean] Success
      # @see http://developer.github.com/v3/git/refs/
      # @example Delete tags/v0.0.3 for sferik/rails_admin
      #   Octokit.delete_ref("sferik/rails_admin","tags/v0.0.3")
      def delete_ref(repo, ref, options = {})
        boolean_from_response :delete, "repos/#{Repository.new(repo)}/git/refs/#{ref}", options
      end
      alias :delete_reference :delete_ref

    end
  end
end

module Octokit
  class Client
    module Commits

      # List commits
      #
      # Optionally pass <tt>path => "path/to/file.rb"</tt> in <tt>options</tt> to
      # only return commits containing the given file path.
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param sha_or_branch [String] Commit SHA or branch name from which to start the list
      # @return [Array] An array of hashes representing commits
      # @see http://developer.github.com/v3/repos/commits/
      def commits(repo, sha_or_branch="master", options={})
        params = { :sha => sha_or_branch, :per_page => 35 }
        get("/repos/#{Repository.new(repo)}/commits", options.merge(params), 3)
      end
      alias :list_commits :commits

      # Get a single commit
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param sha [String] The SHA of the commit to fetch
      # @return [Hashie::Mash] A hash representing the commit
      # @see http://developer.github.com/v3/repos/commits/
      def commit(repo, sha, options={})
        get("/repos/#{Repository.new(repo)}/commits/#{sha}", options, 3)
      end

      # Create a commit
      #
      # Optionally pass <tt>author</tt> and <tt>committer</tt> hashes in <tt>options</tt>
      # if you'd like manual control over those parameters. If absent, details will be
      # inferred from the authenticated user. See <a href="http://developer.github.com/v3/git/commits/">GitHub's documentation</a>
      # for details about how to format committer identities.
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param message [String] The commit message
      # @param tree [String] The SHA of the tree object the new commit will point to
      # @param parents [String, Array] One SHA (for a normal commit) or an array of SHAs (for a merge) of the new commit's parent commits. If ommitted or empty, a root commit will be created
      # @return [Hashie::Mash] A hash representing the new commit
      # @see http://developer.github.com/v3/git/commits/
      # @example Create a commit
      #   commit = Octokit.create_commit("octocat/Hello-World", "My commit message", "827efc6d56897b048c772eb4087f854f46256132", "7d1b31e74ee336d15cbd21741bc88a537ed063a0")
      #   commit.sha # => "7638417db6d59f3c431d3e1f261cc637155684cd"
      #   commit.tree.sha # => "827efc6d56897b048c772eb4087f854f46256132"
      #   commit.message # => "My commit message"
      #   commit.committer # => { "name" => "Wynn Netherland", "email" => "wynn@github.com", ... }
      def create_commit(repo, message, tree, parents=nil, options={})
        params = { :message => message, :tree => tree }.tap do |params|
          params[:parents] = [parents].flatten if parents
        end
        post("/repos/#{Repository.new(repo)}/git/commits", options.merge(params), 3)
      end

      # List all commit comments
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Array] An array of hashes representing comments
      # @see http://developer.github.com/v3/repos/comments/
      def list_commit_comments(repo, options={})
        get("/repos/#{Repository.new(repo)}/comments", options, 3)
      end

      # List comments for a single commit
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param sha [String] The SHA of the commit whose comments will be fetched
      # @return [Array] An array of hashes representing comments
      # @see http://developer.github.com/v3/repos/comments/
      def commit_comments(repo, sha, options={})
        get("/repos/#{Repository.new(repo)}/commits/#{sha}/comments", options, 3)
      end

      # Get a single commit comment
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param id [String] The ID of the comment to fetch
      # @return [Hashie::Mash] A hash representing the comment
      # @see http://developer.github.com/v3/repos/comments/
      def commit_comment(repo, id, options={})
        get("/repos/#{Repository.new(repo)}/comments/#{id}", options, 3)
      end

    end
  end
end

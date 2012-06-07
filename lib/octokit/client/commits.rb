module Octokit
  class Client
    module Commits

      def commits(repo, branch="master", options={})
        options = { :per_page => 35, :sha => branch }.merge options
        get("/repos/#{Repository.new(repo)}/commits", options, 3)
      end
      alias :list_commits :commits

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

      def list_commit_comments(repo, options={})
        get("/repos/#{Repository.new(repo)}/comments", options, 3)
      end

      def commit_comments(repo, sha, options={})
        get("/repos/#{Repository.new(repo)}/commits/#{sha}/comments", options, 3)
      end

      def commit_comment(repo, id, options={})
        get("/repos/#{Repository.new(repo)}/comments/#{id}", options, 3)
      end

    end
  end
end

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
      def commits(repo, sha_or_branch=nil, options={})
        options[:uri][:sha] = sha_or_branch if sha_or_branch
        repository(repo).rels[:commits].get(options).data
      end
      alias :list_commits :commits

      # Get a single commit
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param sha [String] The SHA of the commit to fetch
      # @return [Hashie::Mash] A hash representing the commit
      # @see http://developer.github.com/v3/repos/commits/
      def commit(repo, sha, options={})
        options.merge! :uri => { :sha => sha }
        repository(repo).rels[:commits].get(options).data
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
        params = { :message => message, :tree => tree }
        params[:parents] = [parents].flatten if parents
        post("repos/#{Repository.new(repo)}/git/commits", options.merge(params)).data
      end

      # List all commit comments
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Array] An array of hashes representing comments
      # @see http://developer.github.com/v3/repos/comments/
      def list_commit_comments(repo, options={})
        get("repos/#{Repository.new(repo)}/comments", options).data
      end

      # List comments for a single commit
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param sha [String] The SHA of the commit whose comments will be fetched
      # @return [Array] An array of hashes representing comments
      # @see http://developer.github.com/v3/repos/comments/
      def commit_comments(repo, sha, options={})
        get("repos/#{Repository.new(repo)}/commits/#{sha}/comments").data
      end

      # Get a single commit comment
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param id [String] The ID of the comment to fetch
      # @return [Hashie::Mash] A hash representing the comment
      # @see http://developer.github.com/v3/repos/comments/
      def commit_comment(repo, id, options={})
        get("repos/#{Repository.new(repo)}/comments/#{id}", options).data
      end

      # Create a commit comment
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param sha [String] Sha of the commit to comment on
      # @param body [String] Message
      # @param path [String] Relative path of file to comment on
      # @param line [Integer] Line number in the file to comment on
      # @param position [Integer] Line index in the diff to comment on
      # @return [Hashie::Mash] A hash representing the new commit comment
      # @see http://developer.github.com/v3/repos/comments/
      # @example Create a commit comment
      #   commit = Octokit.create_commit_comment("octocat/Hello-World", "827efc6d56897b048c772eb4087f854f46256132", "My comment message", "README.md", 10, 1)
      #   commit.commit_id # => "827efc6d56897b048c772eb4087f854f46256132"
      #   commit.body # => "My comment message"
      #   commit.path # => "README.md"
      #   commit.line # => 10
      #   commit.position # => 1
      def create_commit_comment(repo, sha, body, path=nil, line=nil, position=nil, options={})
        params = {
          :body => body,
          :commit_id => sha,
          :path => path,
          :line => line,
          :position => position
        }
        post("repos/#{Repository.new(repo)}/commits/#{sha}/comments", options.merge(params)).data
      end

      # Update a commit comment
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param id [String] The ID of the comment to update
      # @param body [String] Message
      # @return [Hashie::Mash] A hash representing the updated commit comment
      # @see http://developer.github.com/v3/repos/comments/
      # @example Update a commit comment
      #   commit = Octokit.update_commit_comment("octocat/Hello-World", "860296", "Updated commit comment")
      #   commit.id # => 860296
      #   commit.body # => "Updated commit comment"
      def update_commit_comment(repo, id, body, options={})
        params = {
          :body => body
        }
        patch("repos/#{Repository.new(repo)}/comments/#{id}", options.merge(params)).data
      end

      # Delete a commit comment
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param id [String] The ID of the comment to delete
      # @return [nil] nil
      # @see http://developer.github.com/v3/repos/comments/
      def delete_commit_comment(repo, id, options={})
        delete("repos/#{Repository.new(repo)}/comments/#{id}", options).data
      end

      # Compare two commits
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param base [String] The sha of the starting commit
      # @param end [String] The sha of the ending commit
      # @return [Hashie::Mash] A hash representing the comparison
      # @see http://developer.github.com/v3/repos/commits/
      def compare(repo, start, endd, options={})
        get("repos/#{Repository.new(repo)}/compare/#{start}...#{endd}", options).data
      end

      # Merge a branch or sha
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param base [String] The name of the base branch to merge into
      # @param head [String] The branch or SHA1 to merge
      # @option options [String] :commit_message The commit message for the merge
      # @return [Hashie::Mash] A hash representing the comparison
      # @see http://developer.github.com/v3/repos/merging/
      def merge(repo, base, head, options={})
        params = {
          :base => base,
          :head => head
        }.merge(options)
        post("repos/#{Repository.new(repo)}/merges", params).data
      end


    end
  end
end

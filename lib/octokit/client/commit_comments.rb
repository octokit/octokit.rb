module Octokit
  class Client

    # Methods for the Commit Comments API
    #
    # @see http://developer.github.com/v3/repos/comments/
    module CommitComments

      # List all commit comments
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @return [Array] List of commit comments
      # @see http://developer.github.com/v3/repos/comments/
      def list_commit_comments(repo, options = {})
        get "repos/#{Repository.new(repo)}/comments", options
      end

      # List comments for a single commit
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param sha [String] The SHA of the commit whose comments will be fetched
      # @return [Array]  List of commit comments
      # @see http://developer.github.com/v3/repos/comments/
      def commit_comments(repo, sha, options = {})
        get "repos/#{Repository.new(repo)}/commits/#{sha}/comments", options
      end

      # Get a single commit comment
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param id [String] The ID of the comment to fetch
      # @return [Sawyer::Resource] Commit comment
      # @see http://developer.github.com/v3/repos/comments/
      def commit_comment(repo, id, options = {})
        get "repos/#{Repository.new(repo)}/comments/#{id}", options
      end

      # Create a commit comment
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param sha [String] Sha of the commit to comment on
      # @param body [String] Message
      # @param path [String] Relative path of file to comment on
      # @param line [Integer] Line number in the file to comment on
      # @param position [Integer] Line index in the diff to comment on
      # @return [Sawyer::Resource] Commit comment
      # @see http://developer.github.com/v3/repos/comments/
      # @example Create a commit comment
      #   commit = Octokit.create_commit_comment("octocat/Hello-World", "827efc6d56897b048c772eb4087f854f46256132", "My comment message", "README.md", 10, 1)
      #   commit.commit_id # => "827efc6d56897b048c772eb4087f854f46256132"
      #   commit.body # => "My comment message"
      #   commit.path # => "README.md"
      #   commit.line # => 10
      #   commit.position # => 1
      def create_commit_comment(repo, sha, body, path=nil, line=nil, position=nil, options = {})
        params = {
          :body => body,
          :commit_id => sha,
          :path => path,
          :line => line,
          :position => position
        }
        post "repos/#{Repository.new(repo)}/commits/#{sha}/comments", options.merge(params)
      end

      # Update a commit comment
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param id [String] The ID of the comment to update
      # @param body [String] Message
      # @return [Sawyer::Resource] Updated commit comment
      # @see http://developer.github.com/v3/repos/comments/
      # @example Update a commit comment
      #   commit = Octokit.update_commit_comment("octocat/Hello-World", "860296", "Updated commit comment")
      #   commit.id # => 860296
      #   commit.body # => "Updated commit comment"
      def update_commit_comment(repo, id, body, options = {})
        params = {
          :body => body
        }
        patch "repos/#{Repository.new(repo)}/comments/#{id}", options.merge(params)
      end

      # Delete a commit comment
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param id [String] The ID of the comment to delete
      # @return [Boolean] Success
      # @see http://developer.github.com/v3/repos/comments/
      def delete_commit_comment(repo, id, options = {})
        boolean_from_response :delete, "repos/#{Repository.new(repo)}/comments/#{id}", options
      end
    end
  end
end

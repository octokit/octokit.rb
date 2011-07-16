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

    end
  end
end

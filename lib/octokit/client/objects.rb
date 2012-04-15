module Octokit
  class Client
    module Objects
      def tree(repo, tree_sha, options={})
        get("repos/#{Repository.new(repo)}/git/trees/#{tree_sha}", options)
      end

      def blob(repo, tree_sha, options={})
        get("repos/#{Repository.new(repo)}/git/blobs/#{tree_sha}", options)
      end

      def blobs(repo, tree_sha, options={})
        warn 'DEPRECATED: Please use Octokit.tree instead.'
        get("/api/v2/json/blob/all/#{Repository.new(repo)}/#{tree_sha}", options, 2)['blobs']
      end

      def blob_metadata(repo, tree_sha, options={})
        warn 'DEPRECATED: Please use Octokit.blob instead.'
        get("/api/v2/json/blob/full/#{Repository.new(repo)}/#{tree_sha}", options, 2)['blobs']
      end
      alias :blob_meta :blob_metadata

      def tree_metadata(repo, tree_sha, options={})
        warn 'DEPRECATED: Please use Octokit.tree instead.'
        get("/api/v2/json/tree/full/#{Repository.new(repo)}/#{tree_sha}", options, 2)['tree']
      end
      alias :tree_meta :tree_metadata

      def raw(repo, sha, options={})
        warn 'DEPRECATED: Please use Octokit.blob instead.'
        get("/api/v2/json/blob/show/#{Repository.new(repo)}/#{sha}", options, 2, true, true).body
      end
    end
  end
end

module Octokit
  class Client
    module Objects
      def tree(repo, tree_sha, options={})
        get("/api/v2/json/tree/show/#{Repository.new(repo)}/#{tree_sha}", options)['tree']
      end

      def blob(repo, tree_sha, path, options={})
        get("/api/v2/json/blob/show/#{Repository.new(repo)}/#{tree_sha}/#{path}", options)['blob']
      end

      # Depreciated
      def blobs(repo, tree_sha, options={})
        get("/api/v2/json/blob/all/#{Repository.new(repo)}/#{tree_sha}", options, 2)['blobs']
      end

      # Depreciated
      def blob_metadata(repo, tree_sha, options={})
        get("/api/v2/json/blob/full/#{Repository.new(repo)}/#{tree_sha}", options, 2)['blobs']
      end
      alias :blob_meta :blob_metadata

      # Depreciated
      def tree_metadata(repo, tree_sha, options={})
        get("/api/v2/json/tree/full/#{Repository.new(repo)}/#{tree_sha}", options, 2)['tree']
      end
      alias :tree_meta :tree_metadata

      # Depreciated
      def raw(repo, sha, options={})
        get("/api/v2/json/blob/show/#{Repository.new(repo)}/#{sha}", options, 2, true, true).body
      end
    end
  end
end

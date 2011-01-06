module Octokit
  class Client
    module Objects

      def tree(repo, tree_sha, options={})
        get("tree/show/#{Repository.new(repo)}/#{tree_sha}", options)['tree']
      end

      def blob(repo, tree_sha, path, options={})
        get("blob/show/#{Repository.new(repo)}/#{tree_sha}/#{path}", options)['blob']
      end

      def blobs(repo, tree_sha, options={})
        get("blob/all/#{Repository.new(repo)}/#{tree_sha}", options)['blobs']
      end

      def blob_metadata(repo, tree_sha, options={})
        get("blob/full/#{Repository.new(repo)}/#{tree_sha}", options)['blobs']
      end
      alias :blob_meta :blob_metadata

      def tree_metadata(repo, tree_sha, options={})
        get("tree/full/#{Repository.new(repo)}/#{tree_sha}", options)['blobs']
      end
      alias :tree_meta :tree_metadata

      def raw(repo, sha, options={})
        get("blob/show/#{Repository.new(repo)}/#{sha}", options)
      end

    end
  end
end

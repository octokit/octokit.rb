module Octokit
  class Client
    module Objects
      def tree(repo, tree_sha, options={})
        get("repos/#{Repository.new(repo)}/git/trees/#{tree_sha}", options)
      end

      def blob(repo, tree_sha, options={})
        get("repos/#{Repository.new(repo)}/git/blobs/#{tree_sha}", options)
      end

      # Create a blob
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param content [String] Content of the blob
      # @param encoding [String] The content's encoding. <tt>utf-8</tt> and <tt>base64</tt> are accepted. If your data cannot be losslessly sent as a UTF-8 string, you can base64 encode it
      # @return [String] The new blob's SHA, e.g. <tt>827efc6d56897b048c772eb4087f854f46256132</tt>
      # @see http://developer.github.com/v3/git/blobs/
      # @example Create a blob containing <tt>foo bar baz</tt>
      #   Octokit.create_blob("octocat/Hello-World", "foo bar baz")
      # @example Create a blob containing <tt>foo bar baz</tt>, encoded using base64
      #   require "base64"
      #   Octokit.create_blob("octocat/Hello-World", Base64.encode64("foo bar baz"), "base64")
      def create_blob(repo, content, encoding="utf-8", options={})
        parameters = {
          :content => content,
          :encoding => encoding
        }
        post("/repos/#{Repository.new(repo)}/git/blobs", options.merge(parameters), 3).sha
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

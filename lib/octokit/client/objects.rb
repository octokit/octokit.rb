module Octokit
  class Client
    module Objects
      # Get a single tree, fetching information about its root-level objects
      #
      # Pass <tt>:recursive => true</tt> in <tt>options</tt> to fetch information about all of the tree's objects, including those in subdirectories.
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param tree_sha [String] The SHA of the tree to fetch
      # @return [Hashie::Mash] A hash representing the fetched tree
      # @see http://developer.github.com/v3/git/trees/
      # @example Fetch a tree and inspect the path of one of its files
      #   tree = Octokit.tree("octocat/Hello-World", "9fb037999f264ba9a7fc6274d15fa3ae2ab98312")
      #   tree.tree.first.path # => "file.rb"
      # @example Fetch a tree recursively
      #   tree = Octokit.tree("octocat/Hello-World", "fc6274d15fa3ae2ab983129fb037999f264ba9a7")
      #   tree.tree.first.path # => "subdir/file.txt"
      def tree(repo, tree_sha, options={})
        get("repos/#{Repository.new(repo)}/git/trees/#{tree_sha}", options)
      end

      # Get a single blob, fetching its content and encoding
      #
      # @param repo [String, Hash, Repository] A GitHub repository
      # @param blob_sha [String] The SHA of the blob to fetch
      # @return [Hashie::Mash] A hash representing the fetched blob
      # @see http://developer.github.com/v3/git/blobs/
      # @example Fetch a blob and inspect its contents
      #    blob = Octokit.blob("octocat/Hello-World", "827efc6d56897b048c772eb4087f854f46256132")
      #    blob.encoding # => "utf-8"
      #    blob.content # => "Foo bar baz"
      # @example Fetch a base64-encoded blob and inspect its contents
      #    require "base64"
      #    blob = Octokit.blob("octocat/Hello-World", "827efc6d56897b048c772eb4087f854f46256132")
      #    blob.encoding # => "base64"
      #    blob.content # => "Rm9vIGJhciBiYXo="
      #    Base64.decode64(blob.content) # => "Foo bar baz"
      def blob(repo, blob_sha, options={})
        get("repos/#{Repository.new(repo)}/git/blobs/#{blob_sha}", options)
      end

      # Create a blob
      #
      # @param repo [String, Hash, Repository] A GitHub repository
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

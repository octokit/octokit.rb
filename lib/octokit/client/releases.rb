module Octokit
  class Client

    # Methods for the Releases API
    #
    # @see http://developer.github.com/v3/repos/releases/
    module Releases

      PREVIEW_MEDIA_TYPE = "application/vnd.github.manifold-preview".freeze

      # List releases for a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of releases
      # @see http://developer.github.com/v3/repos/releases/#list-releases-for-a-repository
      def releases(repo, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        paginate "repos/#{Repository.new(repo)}/releases", options
      end
      alias :list_releases :releases

      # Create a release
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param tag_name [String] Git tag from which to create release
      # @option options [String] :target_commitish Specifies the commitish value that determines where the Git tag is created from.
      # @option options [String] :name Name for the release
      # @option options [String] :body Content for release notes
      # @option options [String] :draft Mark this release as a draft
      # @option options [String] :prerelease Mark this release as a pre-release
      # @return [Sawyer::Resource] The release
      # @see http://developer.github.com/v3/repos/releases/#create-a-release
      def create_release(repo, tag_name, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        opts = options.merge(:tag_name => tag_name)
        post "repos/#{Repository.new(repo)}/releases", opts
      end

      # Get a release
      #
      # @param url [String] URL for the release as returned from .releases
      # @return [Sawyer::Resource] The release
      # @see http://developer.github.com/v3/repos/releases/#get-a-single-release
      def release(url, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        get url, options
      end

      # Update a release
      #
      # @param url [String] URL for the release as returned from .releases
      # @param tag_name [String] Git tag from which to create release
      # @option options [String] :target_commitish Specifies the commitish value that determines where the Git tag is created from.
      # @option options [String] :name Name for the release
      # @option options [String] :body Content for release notes
      # @option options [String] :draft Mark this release as a draft
      # @option options [String] :prerelease Mark this release as a pre-release
      # @return [Sawyer::Resource] The release
      # @see http://developer.github.com/v3/repos/releases/#edit-a-release
      def update_release(url, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        patch url, options
      end
      alias :edit_release :update_release

      # Delete a release
      #
      # @param url [String] URL for the release as returned from .releases
      # @return [Boolean] Success or failure
      # @see http://developer.github.com/v3/repos/releases/#delete-a-release
      def delete_release(url, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        boolean_from_response(:delete, url, options)
      end

      # List release assets
      #
      # @param release_url [String] URL for the release as returned from .releases
      # @return [Array<Sawyer::Resource>] A list of release assets
      # @see http://developer.github.com/v3/repos/releases/#list-assets-for-a-release
      def release_assets(release_url, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        paginate release(release_url).rels[:assets].href, options
      end

      # Upload a release asset
      #
      # @param release_url [String] URL for the release as returned from .releases
      # @param file [String] Path to file to upload
      # @option options [String] :content_type The MIME type for the file to upload
      # @option options [String] :name The name for the file
      # @return [Sawyer::Resource] The release asset
      # @see http://developer.github.com/v3/repos/releases/#upload-a-release-asset
      def upload_asset(release_url, path_or_file, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        file = path_or_file.respond_to?(:read) ? path_or_file : File.new(path_or_file, "r+b")
        options[:content_type] ||= content_type_from_file(file)
        raise Octokit::MissingContentType.new if options[:content_type].nil?
        unless name = options[:name]
          name = File.basename(file.path)
        end
        upload_url = release(release_url).rels[:upload].href_template.expand(:name => name)

        request :post, upload_url, file.read, parse_query_and_convenience_headers(options)
      ensure
        file.close if file
      end

      # Get a single release asset
      #
      #
      # @param asset_url [String] URL for the asset as returned from .release_assets
      # @return [Sawyer::Resource] The release asset
      # @see http://developer.github.com/v3/repos/releases/#get-a-single-release-asset
      def release_asset(asset_url, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        get(asset_url, options)
      end

      # Update a release asset
      #
      # @param asset_url [String] URL for the asset as returned from .release_assets
      # @option options [String] :name The name for the file
      # @option options [String] :label The download text for the file
      # @return [Sawyer::Resource] The release asset
      # @see http://developer.github.com/v3/repos/releases/#get-a-single-release-asset
      def update_release_asset(asset_url, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        patch(asset_url, options)
      end
      alias :edit_release_asset :update_release_asset

      # Delete a release asset
      #
      # @param asset_url [String] URL for the asset as returned from .release_assets
      # @return [Boolean] Success or failure
      # @see http://developer.github.com/v3/repos/releases/#delete-a-release-asset
      def delete_release_asset(asset_url, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        boolean_from_response(:delete, asset_url, options)
      end

      private

      def content_type_from_file(file)
        require 'mime/types'
        if mime_type = MIME::Types.type_for(file.path).first
          mime_type.content_type
        end
      rescue LoadError
        msg = "Please pass content_type or install mime-types gem to guess content type from file"
        raise Octokit::MissingContentType.new msg
      end
    end
  end
end

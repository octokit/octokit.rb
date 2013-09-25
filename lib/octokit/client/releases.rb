module Octokit
  class Client

    # Methods for the Releases API
    #
    # @see http://developer.github.com/v3/repos/releases/
    module Releases

      PREVIEW_MEDIA_TYPE = "application/vnd.github.manifold-preview".freeze

      def releases(repo, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        paginate "repos/#{Repository.new(repo)}/releases", options
      end
      alias :list_releases :releases

      def create_release(repo, tag_name, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        opts = options.merge(:tag_name => tag_name)
        post "repos/#{Repository.new(repo)}/releases", opts
      end

      def release(url, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        get url, options
      end

      def update_release(url, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        patch url, options
      end
      alias :edit_release :update_release

      def delete_release(url, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        boolean_from_response(:delete, url, options)
      end

      def release_assets(release_url, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        paginate release(release_url).rels[:assets].href, options
      end

      def upload_asset(release_url, path_or_file, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        file = File.new(path_or_file, "r+b") unless file.respond_to?(:read)
        if options[:content_type].nil?
          raise ArgumentError.new("content_type option is required")
        end

        unless name = options[:name]
          require 'pathname'
          name = Pathname.new(file).basename.to_s
        end
        upload_url = release(release_url).rels[:upload].href_template.expand(:name => name)

        request :post, upload_url, file.read, parse_query_and_convenience_headers(options)
      ensure
        file.close
      end

      def release_asset(asset_url, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        get(asset_url, options)
      end

      def update_release_asset(asset_url, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        patch(asset_url, options)
      end
      alias :edit_release_asset :update_release_asset

      def delete_release_asset(asset_url, options = {})
        options[:accept] ||= PREVIEW_MEDIA_TYPE
        boolean_from_response(:delete, asset_url, options)
      end
    end
  end
end

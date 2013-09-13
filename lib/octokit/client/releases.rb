module Octokit
  class Client

    # Methods for the Releases API
    #
    # @see http://developer.github.com/v3/repos/releases/
    module Releases

      PREVEIW_MEDIA_TYPE = "application/vnd.github.manifold-preview".freeze

      def releases(repo, options = {})
        options[:accept] ||= PREVEIW_MEDIA_TYPE
        paginate "repos/#{Repository.new(repo)}/releases", options
      end
      alias :list_releases :releases

      def create_release(repo, tag_name, options = {})
        options[:accept] ||= PREVEIW_MEDIA_TYPE
        opts = options.merge(:tag_name => tag_name)
        post "repos/#{Repository.new(repo)}/releases", opts
      end

      def release(url, options = {})
        options[:accept] ||= PREVEIW_MEDIA_TYPE
        get url, options
      end

      def update_release(url, options = {})
        options[:accept] ||= PREVEIW_MEDIA_TYPE
        patch url, options
      end
      alias :edit_release :update_release

      def delete_release(url, options = {})
        options[:accept] ||= PREVEIW_MEDIA_TYPE
        delete url, options
      end

      def assets(release_url, options = {})
        options[:accept] ||= PREVEIW_MEDIA_TYPE
        paginate "#{release_url}/assets", options
      end

    end
  end
end

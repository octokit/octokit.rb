module Octokit
  class Client
    # Methods for the Pages API
    #
    # @see https://developer.github.com/v3/repos/pages/
    module Pages

      # Get information about a Pages site
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return <Sawyer::Resource> A single pages
      # @see https://developer.github.com/v3/repos/pages/#get-information-about-a-pages-site
      def pages(repo, options = {})
        get "#{Repository.path repo}/pages", options
      end

      # Enable a Pages site
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param options [Object] :source source parameter
      # @return <Sawyer::Resource> The new pages site
      # @see https://developer.github.com/v3/repos/pages/#enable-a-pages-site
      def enable_pages_site(repo, options = {})
        post "#{Repository.path repo}/pages", options
      end

      # Update information about a Pages site
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param options [String] :cname Specify a custom domain for the repository. Sending a `null` value will remove the custom domain. For more about custom domains, see "[Using a custom domain with GitHub Pages](https://help.github.com/articles/using-a-custom-domain-with-github-pages/)."
      # @param options [String] :source Update the source for the repository. Must include the branch name, and may optionally specify the subdirectory `/docs`. Possible values are `"gh-pages"`, `"master"`, and `"master /docs"`.
      # @return <Sawyer::Resource> True if successful
      # @see https://developer.github.com/v3/repos/pages/#update-information-about-a-pages-site
      def update_pages_site(repo, options = {})
        put "#{Repository.path repo}/pages", options
      end

      # Disable a Pages site
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return <Sawyer::Resource> True if successful
      # @see https://developer.github.com/v3/repos/pages/#disable-a-pages-site
      def delete_pages_site(repo, options = {})
        boolean_from_response :delete, "#{Repository.path repo}/pages", options
      end

      # Get a specific Pages build
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param build_id [Integer] The ID of the build
      # @return <Sawyer::Resource> A single pages build
      # @see https://developer.github.com/v3/repos/pages/#get-a-specific-pages-build
      def pages_build(repo, build_id, options = {})
        get "#{Repository.path repo}/pages/builds/#{build_id}", options
      end

      # List Pages builds
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of pages builds
      # @see https://developer.github.com/v3/repos/pages/#list-pages-builds
      def pages_builds(repo, options = {})
        get "#{Repository.path repo}/pages/builds", options
      end
      alias :list_pages_builds :pages_builds

      # Request a page build
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return <Sawyer::Resource> The new page build
      # @see https://developer.github.com/v3/repos/pages/#request-a-page-build
      def request_page_build(repo, options = {})
        post "#{Repository.path repo}/pages/builds", options
      end

      # Get latest Pages build
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of latest pages build
      # @see https://developer.github.com/v3/repos/pages/#get-latest-pages-build
      def latest_pages_build(repo, options = {})
        get "#{Repository.path repo}/pages/builds/latest", options
      end
      alias :list_latest_pages_build :latest_pages_build
    end
  end
end

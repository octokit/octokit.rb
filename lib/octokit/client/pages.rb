module Octokit
  class Client

    # Methods for the Pages API
    #
    # @see https://developer.github.com/v3/repos/pages/
    module Pages

      # List Pages information for a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return Sawyer::Resource A GitHub Pages resource
      # @see https://developer.github.com/v3/repos/pages/#get-information-about-a-pages-site
      def pages(repo, options = {})
        get "#{Repository.path repo}/pages", options
      end

      # List Pages builds for a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of build history for a repository.
      # @see https://developer.github.com/v3/repos/pages/#list-pages-builds
      def pages_builds(repo, options = {})
        get "#{Repository.path repo}/pages/builds", options
      end
      alias :list_pages_builds :pages_builds

      # List the latest Pages build information for a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return Sawyer::Resource A GitHub Pages resource about a build
      # @see https://developer.github.com/v3/repos/pages/#list-latest-pages-build
      def latest_pages_build(repo, options = {})
        get "#{Repository.path repo}/pages/builds/latest", options
      end
    end
  end
end

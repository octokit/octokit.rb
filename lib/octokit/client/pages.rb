module Octokit
  class Client

    # Methods for the Pages API
    #
    # @see http://developer.github.com/v3/repos/pages/
    module Pages

      # List Pages information for a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @return Sawyer::Resource A GitHub Pages resource
      # @see http://developer.github.com/v3/repos/pages/#pages
      def pages(repo, options = {})
        get "repos/#{Repository.new(repo)}/page", options
      end

      # List Pages builds for a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of build history for a repository.
      # @see http://developer.github.com/v3/repos/pages/#pages-builds
      def pages_builds(repo, options = {})
        get "repos/#{Repository.new(repo)}/page/builds", options
      end
      alias :list_page_builds :pages_builds

      # List the latest Pages build information for a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @return Sawyer::Resource A GitHub Pages resource about a build
      # @see http://developer.github.com/v3/repos/pages/#latest-pages-build
      def latest_pages_build(repo, options = {})
        get "repos/#{Repository.new(repo)}/page/builds/latest", options
      end
    end
  end
end

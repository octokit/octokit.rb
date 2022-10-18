# frozen_string_literal: true

module Octokit
  class Client
    # Methods for the ReposPages API
    #
    # @see https://developer.github.com/v3/repos/pages/
    module ReposPages
      # Get a GitHub Pages site
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Sawyer::Resource] A single pages
      # @see https://developer.github.com/v3/repos/pages/#get-a-github-pages-site
      def pages(repo, options = {})
        get "#{Repository.path repo}/pages", options
      end

      # Create a GitHub Pages site
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [Object] :source The source of the site
      # @return [Sawyer::Resource] The new site
      # @see https://developer.github.com/v3/repos/pages/#create-a-github-pages-site
      def create_pages_site(repo, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.switcheroo-preview+json' if opts[:accept].nil?

        post "#{Repository.path repo}/pages", opts
      end

      # Update information about a GitHub Pages site
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @option options [String] :cname Specify a custom domain for the repository. Sending a null value will remove the custom domain. For more about custom domains, see "Using a custom domain with GitHub Pages (https://help.github.com/articles/using-a-custom-domain-with-github-pages/)."
      # @option options [String] :source Update the source for the repository. Must include the branch name, and may optionally specify the subdirectory /docs. Possible values are "gh-pages", "master", and "master /docs".
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/repos/pages/#update-information-about-a-github-pages-site
      def update_pages_site(repo, options = {})
        boolean_from_response :put, "#{Repository.path repo}/pages", options
      end

      # Delete a GitHub Pages site
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/repos/pages/#delete-a-github-pages-site
      def delete_pages_site(repo, options = {})
        opts = options.dup
        opts[:accept] = 'application/vnd.github.switcheroo-preview+json' if opts[:accept].nil?

        boolean_from_response :delete, "#{Repository.path repo}/pages", opts
      end

      # Get GitHub Pages build
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param build_id [Integer] The ID of the build
      # @return [Sawyer::Resource] A single build
      # @see https://developer.github.com/v3/repos/pages/#get-github-pages-build
      def pages_build(repo, build_id, options = {})
        get "#{Repository.path repo}/pages/builds/#{build_id}", options
      end

      # List GitHub Pages builds
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of builds
      # @see https://developer.github.com/v3/repos/pages/#list-github-pages-builds
      def pages_builds(repo, options = {})
        paginate "#{Repository.path repo}/pages/builds", options
      end

      # Request a GitHub Pages build
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Sawyer::Resource] The new build
      # @see https://developer.github.com/v3/repos/pages/#request-a-github-pages-build
      def request_pages_build(repo, options = {})
        post "#{Repository.path repo}/pages/builds", options
      end

      # Get latest Pages build
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Sawyer::Resource] The latest build
      # @see https://developer.github.com/v3/repos/pages/#get-latest-pages-build
      def latest_pages_build(repo, options = {})
        get "#{Repository.path repo}/pages/builds/latest", options
      end
    end
  end
end

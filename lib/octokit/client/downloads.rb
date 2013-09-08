module Octokit
  class Client

    # Methods for the Repo Downloads API
    #
    # @see http://developer.github.com/v3/repos/downloads/
    module Downloads

      # List available downloads for a repository
      #
      # @param repo [String, Repository, Hash] A Github Repository
      # @return [Array] A list of available downloads
      # @deprecated As of December 11th, 2012: https://github.com/blog/1302-goodbye-uploads
      # @see http://developer.github.com/v3/repos/downloads/#list-downloads-for-a-repository
      # @example List all downloads for Github/Hubot
      #   Octokit.downloads("github/hubot")
      def downloads(repo, options={})
        get "repos/#{Repository.new(repo)}/downloads", options
      end
      alias :list_downloads :downloads

      # Get single download for a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param id [Integer] ID of the download
      # @return [Sawyer::Resource] A single download from the repository
      # @deprecated As of December 11th, 2012: https://github.com/blog/1302-goodbye-uploads
      # @see http://developer.github.com/v3/repos/downloads/#get-a-single-download
      # @example Get the "Robawt" download from Github/Hubot
      #   Octokit.download("github/hubot")
      def download(repo, id, options={})
        get "repos/#{Repository.new(repo)}/downloads/#{id}", options
      end

      # Create a download in a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param name [String, Repository, Hash] A display name for the download
      # @option options [String] :description The download description
      # @option options [String] :content_type The content type. Defaults to 'text/plain'
      # @return [Sawyer::Resource] A single download from the repository
      # @deprecated As of December 11th, 2012: https://github.com/blog/1302-goodbye-uploads
      # @see http://developer.github.com/v3/repos/downloads/#create-a-new-download-part-1-create-the-resource
      # @example Create the "Robawt" download on Github/Hubot
      #   Octokit.create_download("github/hubot", 'Robawt')
      def create_download(repo, name, options={})
        options[:content_type] ||= 'text/plain'
        file = Faraday::UploadIO.new(name, options[:content_type])
        resource = create_download_resource(repo, file.original_filename, File.size(name), options)

        resource_hash = {
          'key' => resource.path,
          'acl' => resource.acl,
          'success_action_status' => 201,
          'Filename' => resource.name,
          'AWSAccessKeyId' => resource.accesskeyid,
          'Policy' => resource.policy,
          'Signature' => resource.signature,
          'Content-Type' => resource.mime_type,
          'file' => file
        }

        conn = Faraday.new(resource.rels[:s3].href) do |builder|
          builder.request :multipart
          builder.request :url_encoded
          builder.adapter :net_http
        end

        response = conn.post '/', resource_hash
        response.status == 201
      end

      # Delete a single download for a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param id [Integer] ID of the download
      # @deprecated As of December 11th, 2012: https://github.com/blog/1302-goodbye-uploads
      # @see http://developer.github.com/v3/repos/downloads/#delete-a-single-download
      # @return [Boolean] Status
      # @example Get the "Robawt" download from Github/Hubot
      #   Octokit.delete_download("github/hubot", 1234)
      def delete_download(repo, id, options = {})
        boolean_from_response :delete, "repos/#{Repository.new(repo)}/downloads/#{id}", options
      end

      private

      def create_download_resource(repo, name, size, options={})
        post "repos/#{Repository.new(repo)}/downloads", options.merge({:name => name, :size => size})
      end
    end
  end
end

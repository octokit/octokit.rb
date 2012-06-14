module Octokit
  class Client
    module Downloads 

      # List available downloads for a repository
      #
      # @param repo [String, Repository, Hash] A Github Repository
      # @return [Array] A list of available downloads
      # @see http://developer.github.com/v3/repos/downloads/#list-downloads-for-a-repository
      # @example List all downloads for Github/Hubot
      #   Octokit.downloads("github/hubot")
      def downloads(repo, options={})
        get("repos/#{Repository.new(repo)}/downloads", options, 3)
      end

      # Get single download for a repository
      #
      # @param repo [String, Repository, Hash] A GitHub repository
      # @param id [Integer] ID of the download 
      # @return [Download] A single download from the repository
      # @see http://developer.github.com/v3/repos/downloads/#get-a-single-download
      # @example Get the "Robawt" download from Github/Hubot 
      #   Octokit.download("github/hubot")
      def download(repo, id, options={})
        get("repos/#{Repository.new(repo)}/downloads/#{id}", options, 3)
      end

      
      def create_download(repo, name, options={})
        options[:content_type] ||= 'text/plain'
        file = Faraday::UploadIO.new(name, options[:content_type])
        resource = create_download_resource(repo, file.original_filename, file.size, options)

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

        conn = Faraday.new('https://github.s3.amazonaws.com') do |builder|
          builder.request :multipart
          builder.request :url_encoded
          builder.response :logger
          builder.adapter :net_http
        end

        response = conn.post '/', resource_hash
        puts response.body
      end

      private
      def create_download_resource(repo, name, size, options={})
        post("/repos/#{Repository.new(repo)}/downloads", options.merge({:name => name, :size => size}))
      end
    end
  end
end

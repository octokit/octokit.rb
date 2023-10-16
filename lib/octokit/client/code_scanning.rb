# frozen_string_literal: true

require 'base64'
require 'tempfile'
require 'zlib'

module Octokit
  class Client
    # Methods for the code scanning alerts API
    #
    # @see https://docs.github.com/rest/code-scanning
    module CodeScanning
      # Uploads SARIF data containing the results of a code scanning analysis
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param file [String] Path to the SARIF file to upload
      # @param sha [String] The SHA of the commit to which the analysis you are uploading relates
      # @param ref [String] The full Git reference, formatted as `refs/heads/<branch name>`, `refs/pull/<number>/merge`, or `refs/pull/<number>/head`
      #
      # @return [Sawyer::Resource] SARIF upload information
      # @see https://docs.github.com/rest/code-scanning#upload-an-analysis-as-sarif-data
      def upload_sarif_data(repo, file, sha, ref, options = {})
        options[:sarif] = compress_sarif_data(file)
        options[:commit_sha] = sha
        options[:ref] = ref

        post "#{Repository.path repo}/code-scanning/sarifs", options
      end

      # Gets information about a SARIF upload
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param sarif_id [String] The SARIF ID obtained after uploading
      #
      # @return [Sawyer::Resource] SARIF upload information
      # @see https://docs.github.com/rest/code-scanning#get-information-about-a-sarif-upload
      def get_sarif_upload_information(repo, sarif_id, options = {})
        get "#{Repository.path repo}/code-scanning/sarifs/#{sarif_id}", options
      end

      private

      def compress_sarif_data(file)
        Tempfile.create('sarif.gz') do |tempfile|
          Zlib::GzipWriter.open(tempfile) do |gz_file|
            gz_file.write File.binread(file)
          end
          Base64.strict_encode64(tempfile.read)
        end
      end
    end
  end
end

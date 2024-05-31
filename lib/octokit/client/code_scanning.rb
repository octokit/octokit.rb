# frozen_string_literal: true

require 'tempfile'
require 'zlib'

module Octokit
  class Client
    # Methods for the code scanning alerts API
    #
    # @see https://docs.github.com/rest/code-scanning
    module CodeScanning
      def update_code_scanning_default_config(repo, state, query_suite=nil, languages=nil, options = {})
        options[:state] = state
        options[:query_suite] = query_suite if query_suite
        options[:languages] = languages if languages

        patch "#{Repository.path repo}/code-scanning/default-setup", options
      end

      def get_code_scanning_default_config(repo, options = {})
        get "#{Repository.path repo}/code-scanning/default-setup", options
      end

      def get_codeql_database_for_repo(repo, language, options = {})
        get "#{Repository.path repo}/code-scanning/codeql/databases/#{language}", options
      end

      def list_codeql_database_for_repo(repo, options = {})
        get "#{Repository.path repo}/code-scanning/codeql/databases", options
      end

      def delete_code_scanning_analysis(repo, analysis_id, options = {})
        delete "#{Repository.path repo}/code-scanning/analyses/#{analysis_id}", options
      end

      def get_code_scanning_analysis(repo, analysis_id, options = {})
        get "#{Repository.path repo}/code-scanning/analyses/#{analysis_id}", options
      end

      def list_code_scanning_analysis(repo, options = {})
        get "#{Repository.path repo}/code-scanning/analyses", options
      end

      def list_instances_of_code_scanning_alert(repo, alert_number, options = {})
        get "#{Repository.path repo}/code-scanning/alerts/#{alert_number}/instances", options
      end

      def update_code_scanning_alert(repo, alert_number, status, reason=nil, comment=nil, options = {})
        options[:state] = status
        options[:dismissed_reason] = reason
        options[:dismissed_comment] = comment
        patch "#{Repository.path repo}/code-scanning/alerts/#{alert_number}", options
      end

      def get_code_scanning_alert(repo, alert_number, options = {})
        get "#{Repository.path repo}/code-scanning/alerts/#{alert_number}", options
      end

      def list_code_scanning_alerts_for_repository(repo, options = {})
        get "#{Repository.path repo}/code-scanning/alerts", options
      end

      def list_code_scanning_alerts_for_org(org, options = {})
        get "orgs/#{org}/code-scanning/alerts", options
      end

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
          [tempfile.read].pack('m0') # Base64.strict_encode64
        end
      end
    end
  end
end

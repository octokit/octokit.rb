module Octokit
  class Client

    # Methods for the Commit Statuses API
    #
    # @see https://developer.github.com/v3/repos/statuses/
    module Statuses
      COMBINED_STATUS_MEDIA_TYPE = "application/vnd.github.she-hulk-preview+json"

      # List all statuses for a given commit
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param sha [String] The SHA1 for the commit
      # @return [Array<Sawyer::Resource>] A list of statuses
      # @see https://developer.github.com/v3/repos/statuses/#list-statuses-for-a-specific-ref
      def statuses(repo, sha, options = {})
        get "#{Repository.path repo}/statuses/#{sha}", options
      end
      alias :list_statuses :statuses

      # Get the combined status for a ref
      #
      # @param repo [Integer, String, Repository, Hash] a GitHub repository
      # @param ref  [String] A Sha or Ref to fetch the status of
      # @return [Sawyer::Resource] The combined status for the commit
      # @see https://developer.github.com/v3/repos/statuses/#get-the-combined-status-for-a-specific-ref
      def combined_status(repo, ref, options = {})
        ensure_combined_status_api_media_type(options)
        get "#{Repository.path repo}/commits/#{ref}/status", options
      end
      alias :status :combined_status

      # Create status for a commit
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param sha [String] The SHA1 for the commit
      # @param state [String] The state: pending, success, failure, error
      # @option options [String] :context A context to differentiate this status from others
      # @option options [String] :target_url A link to more details about this status
      # @option options [String] :description A short human-readable description of this status
      # @return [Sawyer::Resource] A status
      # @see https://developer.github.com/v3/repos/statuses/#create-a-status
      def create_status(repo, sha, state, options = {})
        options.merge!(:state => state)
        post "#{Repository.path repo}/statuses/#{sha}", options
      end

      private

      def ensure_combined_status_api_media_type(options = {})
        unless options[:accept]
          options[:accept] = COMBINED_STATUS_MEDIA_TYPE
          warn_combined_status_preview
        end
        options
      end

      def warn_combined_status_preview
        octokit_warn <<-EOS
WARNING: The preview version of the combined status API is not yet suitable
for production use. You can avoid this message by supplying an appropriate
media type in the 'Accept' header. See the blog post for details http://git.io/wtsdaA
EOS
      end
    end
  end
end

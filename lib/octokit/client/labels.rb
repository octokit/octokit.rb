module Octokit
  class Client
    # Methods for the Labels API
    #
    # @see https://developer.github.com/v3/issues/labels/
    module Labels

      # List all labels for this repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @return [Array<Sawyer::Resource>] A list of repository labels
      # @see https://developer.github.com/v3/issues/labels/#list-all-labels-for-this-repository
      def repository_labels(repo, options = {})
        paginate "#{Repository.path repo}/labels", options
      end

      # Create a label
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param name [String] The name of the label. Emoji can be added to label names, using either native emoji or colon-style markup. For example, typing `:strawberry:` will render the emoji ![:strawberry:](https://github.githubassets.com/images/icons/emoji/unicode/1f353.png ":strawberry:"). For a full list of available emoji and codes, see [emoji-cheat-sheet.com](http://emoji-cheat-sheet.com/).
      # @param color [String] The [hexadecimal color code](http://www.color-hex.com/) for the label, without the leading `#`.
      # @option options [String] :description A short description of the label.
      # @return [Sawyer::Resource] The new label
      # @see https://developer.github.com/v3/issues/labels/#create-a-label
      def create_label(repo, name, color, options = {})
        options[:name] = name
        options[:color] = color
        post "#{Repository.path repo}/labels", options
      end

      # Get a single label
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param name [String] The name of the label
      # @return [Sawyer::Resource] A single label
      # @see https://developer.github.com/v3/issues/labels/#get-a-single-label
      def label(repo, name, options = {})
        get "#{Repository.path repo}/labels/#{name}", options
      end

      # Update a label
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param name [String] The name of the label
      # @option options [String] :new_name The new name of the label. Emoji can be added to label names, using either native emoji or colon-style markup. For example, typing `:strawberry:` will render the emoji ![:strawberry:](https://github.githubassets.com/images/icons/emoji/unicode/1f353.png ":strawberry:"). For a full list of available emoji and codes, see [emoji-cheat-sheet.com](http://emoji-cheat-sheet.com/).
      # @option options [String] :color The [hexadecimal color code](http://www.color-hex.com/) for the label, without the leading `#`.
      # @option options [String] :description A short description of the label.
      # @return [Sawyer::Resource] The updated label
      # @see https://developer.github.com/v3/issues/labels/#update-a-label
      def update_label(repo, name, options = {})
        patch "#{Repository.path repo}/labels/#{name}", options
      end

      # Delete a label
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param name [String] The name of the label
      # @return [Boolean] True on success, false otherwise
      # @see https://developer.github.com/v3/issues/labels/#delete-a-label
      def delete_label(repo, name, options = {})
        boolean_from_response :delete, "#{Repository.path repo}/labels/#{name}", options
      end
    end
  end
end

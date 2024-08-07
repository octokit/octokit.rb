# frozen_string_literal: true

module Octokit
  # Class to parse GitHub repository owner and name from
  # URLs and to generate URLs
  class Repository
    attr_accessor :owner, :name, :id

    NAME_WITH_OWNER_PATTERN = %r{\A[\w.-]+/[\w.-]+\z}i.freeze

    # Instantiate from a GitHub repository URL
    #
    # @return [Repository]
    def self.from_url(url)
      new URI.parse(url).path[1..]
             .gsub(%r{^repos/}, '')
             .split('/', 3)[0..1]
             .join('/')
    end

    # @raise [Octokit::InvalidRepository] if the repository
    #   has an invalid format
    def initialize(repo)
      case repo
      when Integer
        @id = repo
      when NAME_WITH_OWNER_PATTERN
        @owner, @name = repo.split('/')
      when Repository
        @owner = repo.owner
        @name = repo.name
      when Hash
        @name = repo[:repo] || repo[:name]
        @owner = repo[:owner] || repo[:user] || repo[:username]
      else
        raise_invalid_repository!(repo)
      end
      validate_owner_and_name!(repo) if @owner && @name
    end

    # Repository owner/name
    # @return [String]
    def slug
      "#{@owner}/#{@name}"
    end
    alias to_s slug

    # @return [String] Repository API path
    def path
      return named_api_path if @owner && @name

      id_api_path if @id
    end

    # Get the api path for a repo
    # @param repo [Integer, String, Hash, Repository] A GitHub repository.
    # @return [String] Api path.
    def self.path(repo)
      new(repo).path
    end

    # @return [String] Api path for owner/name identified repos
    def named_api_path
      "repos/#{slug}"
    end

    # @return [String] Api path for id identified repos
    def id_api_path
      "repositories/#{@id}"
    end

    # Repository URL based on {Octokit::Client#web_endpoint}
    # @return [String]
    def url
      "#{Octokit.web_endpoint}#{slug}"
    end

    alias user owner
    alias username owner
    alias repo name

    private

    ABS_URI_REGEXP = if URI.const_defined?(:RFC2396_PARSER) # Ruby 3.4+
                       URI::RFC2396_PARSER.regexp.fetch(:ABS_URI)
                     else
                       URI::RFC2396_Parser.new.regexp.fetch(:ABS_URI)
                     end

    def validate_owner_and_name!(repo)
      if @owner.include?('/') || @name.include?('/') || !url.match?(ABS_URI_REGEXP)
        raise_invalid_repository!(repo)
      end
    end

    def raise_invalid_repository!(repo)
      msg = "#{repo.inspect} is invalid as a repository identifier. " \
            'Use the user/repo (String) format, or the repository ID (Integer), or a hash containing :repo and :user keys.'
      raise Octokit::InvalidRepository, msg
    end
  end
end

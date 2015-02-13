module Octokit

  # Class to parse GitHub repository owner and name from
  # URLs and to generate URLs
  class Repository
    attr_accessor :owner, :name, :id

    # Instantiate from a GitHub repository URL
    #
    # @return [Repository]
    def self.from_url(url)
      Repository.new(URI.parse(url).path[1..-1])
    end

    def initialize(repo)
      case repo
      when Integer
        @id = repo
      when String
        @owner, @name = repo.split('/')
        unless @owner && @name
          raise ArgumentError, "Invalid Repository. Use user/repo format."
        end
      when Repository
        @owner = repo.owner
        @name = repo.name
      when Hash
        @name = repo[:repo] ||= repo[:name]
        @owner = repo[:owner] ||= repo[:user] ||= repo[:username]
      end
    end

    # Repository owner/name
    # @return [String]
    def slug
      "#{@owner}/#{@name}"
    end
    alias :to_s :slug

    # @return [String] Repository API path
    def path
      return named_api_path if @owner && @name
      return id_api_path if @id
    end

    # Get the api path for a repo
    # @param repo [Integer, String, Hash, Repository] A GitHub repository.
    # @return [String] Api path.
    def self.path repo
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

    alias :user :owner
    alias :username :owner
    alias :repo :name
  end
end

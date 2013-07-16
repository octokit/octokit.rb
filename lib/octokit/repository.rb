module Octokit

  # Class to parse GitHub repository owner and name from
  # URLs and to generate URLs
  class Repository
    attr_accessor :owner, :name

    # Instantiate from a GitHub repository URL
    #
    # @return [Repository]
    def self.from_url(url)
      Repository.new(URI.parse(url).path[1..-1])
    end

    def initialize(repo)
      case repo
      when String
        @owner, @name = repo.split('/')
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

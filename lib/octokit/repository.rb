require 'addressable/uri'

module Octokit
  
  # Class to parse GitHub repository owner and name from 
  # URLs and to generate URLs
  class Repository
    attr_accessor :username, :name

    # Instantiate from a GitHub repository URL
    #
    # @return [Repository]
    def self.from_url(url)
      Repository.new(Addressable::URI.parse(url).path[1..-1])
    end

    def initialize(repo)
      case repo
      when String
        @username, @name = repo.split('/')
      when Repository
        @username = repo.username
        @name = repo.name
      when Hash
        @name = repo[:repo] ||= repo[:name]
        @username = repo[:username] ||= repo[:user] ||= repo[:owner]
      end
    end

    # Repository owner/name
    # @return [String]
    def slug
      "#{@username}/#{@name}"
    end
    alias :to_s :slug

    # Repository URL based on {Octokit::Client#web_endpoint}
    # @return [String]
    def url
      "#{Octokit.web_endpoint}#{slug}"
    end

    alias :user :username
    alias :repo :name
  end
end

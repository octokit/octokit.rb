require 'addressable/uri'

module Octokit
  class Repository
    attr_accessor :username, :name

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

    def slug
      "#{@username}/#{@name}"
    end

    def to_s
      self.slug
    end

    def url
      "#{Octokit.web_endpoint}#{slug}"
    end

    alias :user :username
    alias :repo :name
  end
end

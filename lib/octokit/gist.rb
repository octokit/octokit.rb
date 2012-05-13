require 'addressable/uri'

module Octokit
  class Gist
    attr_accessor :id

    def self.from_url(url)
      Gist.new(Addressable::URI.parse(url).path[1..-1])
    end

    def initialize(gist)
      case gist
      when Fixnum, String
        @id = gist.to_s
      end
    end

    def to_s
      @id
    end

    def url
      "https://gist.github.com/#{@id}"
    end

  end
end

require 'octokit/error'

module Octokit
  class Error
    # Raised when JSON parsing fails
    class ParserError < Octokit::Error
    end
  end
end

module Octokit
  # GitHub user class to generate API path urls
  class User
    # Get the api path for a user
    #
    # @param user [String, Integer] GitHub user login or id
    # @return [String] User Api path
    def self.path user
      return "users/#{user}" if user.is_a? String
      return "user/#{user}" if user.is_a? Integer
      "user"
    end
  end
end

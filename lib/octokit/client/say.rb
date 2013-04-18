module Octokit
  class Client
    module Say

      def say(text=nil)
        options = {}
        options[:s] = text if text
        get "/octocat", :query => options
      end
      alias :octocat :say

    end
  end
end

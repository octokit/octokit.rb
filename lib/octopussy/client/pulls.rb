module Octopussy
  class Client
    module Pulls
      def create_pull_request(repo, options={})
        post("pulls/#{Repository.new(repo)}", options)['pulls']
      end

      def pull_requests(repo, state='open', options={})
        get("pulls/#{Repository.new(repo)}/#{state}", options)['pulls']
      end
      alias :pulls :pull_requests

      def pull_request(repo, number, options={})
        get("pulls/#{Repository.new(repo)}/#{number}", options)['pulls']
      end
      alias :pull :pull_request
    end
  end
end

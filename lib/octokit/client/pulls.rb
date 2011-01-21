module Octokit
  class Client
    module Pulls
      def create_pull_request(repo, base, head, title, body, options={})
        pull = {
          :base  => base,
          :head  => head,
          :title => title,
          :body  => body,
        }
        post("pulls/#{Repository.new(repo)}", options.merge({:pull => pull}))['pulls']
      end

      def pull_requests(repo, state='open', options={})
        get("pulls/#{Repository.new(repo)}/#{state}", options)['pulls']
      end
      alias :pulls :pull_requests

      def pull_request(repo, number, options={})
        get("pulls/#{Repository.new(repo)}/#{number}", options)['pull']
      end
      alias :pull :pull_request
    end
  end
end

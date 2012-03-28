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
        post("repos/#{Repository.new(repo)}/pulls", options.merge(pull))
      end

      def create_pull_request_for_issue(repo, base, head, issue, options={})
        pull = {
          :base  => base,
          :head  => head,
          :issue => issue
        }
        post("repos/#{Repository.new(repo)}/pulls", options.merge(pull))
      end

      def pull_requests(repo, state='open', options={})
        get("repos/#{Repository.new(repo)}/pulls", options.merge({:state => state}), 3)
      end
      alias :pulls :pull_requests

      def pull_request(repo, number, options={})
        get("repos/#{Repository.new(repo)}/pulls/#{number}", options)
      end
      alias :pull :pull_request
    end
  end
end

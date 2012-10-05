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

      def pull_request_commits(repo, number, options={})
        get("repos/#{Repository.new(repo)}/pulls/#{number}/commits", options)
      end
      alias :pull_commits :pull_request_commits

      def pull_request_files(repo, number, options={})
        get("repos/#{Repository.new(repo)}/pulls/#{number}/files", options)
      end
      alias :pull_files :pull_request_files

      def merge_pull_request(repo, number, commit_message='', options={})
        put("repos/#{Repository.new(repo)}/pulls/#{number}/merge", options.merge({:commit_message => commit_message}))
      end
    end
  end
end

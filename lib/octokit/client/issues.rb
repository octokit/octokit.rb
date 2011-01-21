module Octokit
  class Client
    module Issues

      def search_issues(repo, search_term, state='open', options={})
        get("issues/search/#{Repository.new(repo)}/#{state}/#{search_term}", options)['issues']
      end

      def issues(repo, state='open', options={})
        get("issues/list/#{Repository.new(repo)}/#{state}", options)['issues']
      end
      alias :list_issues :issues

      def issues_labeled(repo, label, options={})
        get("issues/list/#{Repository.new(repo)}/label/#{label}", options)['issues']
      end

      def issue(repo, number, options={})
        get("issues/show/#{Repository.new(repo)}/#{number}", options)['issue']
      end

      def issue_comments(repo, number, options={})
        get("issues/comments/#{Repository.new(repo)}/#{number}", options)['comments']
      end

      def create_issue(repo, title, body, options={})
        post("issues/open/#{Repository.new(repo)}", options.merge({:title => title, :body => body}))['issue']
      end
      alias :open_issue :create_issue

      def close_issue(repo, number, options={})
        post("issues/close/#{Repository.new(repo)}/#{number}", options)['issue']
      end

      def reopen_issue(repo, number, options={})
        post("issues/reopen/#{Repository.new(repo)}/#{number}", options)['issue']
      end

      def update_issue(repo, number, title, body, options={})
        post("issues/edit/#{Repository.new(repo)}/#{number}", options.merge({:title => title, :body => body}))['issue']
      end

      def labels(repo, options={})
        get("issues/labels/#{Repository.new(repo)}", options)['labels']
      end

      def add_label(repo, label, number=nil, options={})
        post(["issues/label/add/#{Repository.new(repo)}/#{label}", number].compact.join('/'), options)['labels']
      end

      def remove_label(repo, label, number=nil, options={})
        post(["issues/label/remove/#{Repository.new(repo)}/#{label}", number].compact.join('/'), options)['labels']
      end

      def add_comment(repo, number, comment, options={})
        post("issues/comment/#{Repository.new(repo)}/#{number}", options.merge({:comment => comment}))['comment']
      end
    end
  end
end

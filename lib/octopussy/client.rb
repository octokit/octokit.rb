require 'cgi'
module Octopussy
  class Client
    include HTTParty
    format :json
    base_uri "http://github.com/api/v2/json"
    
    attr_reader :login, :token
    
    # :login => 'pengwynn', :token => 'your_github_api_key'
    def initialize(auth={})
      if auth[:password].nil?
        @login = auth[:login]
        @token = auth[:token]
        self.class.basic_auth(nil, nil)
      else
        @login = auth[:login]
        self.class.basic_auth(@login, auth[:password])
      end      
    end
    
    def search_users(q)
      q = CGI.escape(q)
      response = self.class.get("/user/search/#{q}")
      Hashie::Mash.new(response).users
    end
    
    def user(login=self.login)
      get("/user/show/#{login}", :query => auth_params).user
    end

    def update_user(values={})
      post("/user/show/#{self.login}", :query => auth_params, :body => {:values => values}).user
    end
    
    def followers(login=self.login)
      get("/user/show/#{login}/followers").users
    end
    
    def following(login=self.login)
      get("/user/show/#{login}/following").users
    end
    
    def follow!(username)
      post("/user/follow/#{username}", :query => auth_params).users
    end
    
    def unfollow!(username)
      post("/user/unfollow/#{username}", :query => auth_params).users
    end
    
    def follows?(*args)
      target = args.pop
      username = args.first 
      username ||= self.login
      return if username.nil?
      self.following(username).include?(target)
    end
    
    def watched(login=self.login)
      get("/repos/watched/#{login}").repositories
    end
    
    def emails
      get("/user/emails", :query => auth_params).emails
    end
    
    def add_email(email)
      post("/user/email/add", :query => auth_params, :body => {:email => email}).emails
    end
    
    def remove_email(email)
      post("/user/email/remove", :query => auth_params, :body => {:email => email}).emails
    end
    
    def keys
      get("/user/keys", :query => auth_params).public_keys
    end
    
    def add_key(title, key)
      post("/user/key/add", :query => auth_params, :body => {:title => title, :key => key}).public_keys
    end
    
    def remove_key(id)
      post("/user/key/remove", :query => auth_params, :body => {:id => id}).public_keys
    end

    # Issues
    
    def search_issues(repo, state, q)
      get("/issues/search/#{Repo.new(repo)}/#{state}/#{q}").issues
    end
    
    def issues(repo, state)
      get("/issues/list/#{Repo.new(repo)}/#{state}").issues
    end
    
    def issue(repo, id)
      get("/issues/show/#{Repo.new(repo)}/#{id}").issue
    end

    def open_issue(repo, title, body)
      post("/issues/open/#{Repo.new(repo)}", :body => {:title => title, :body => body}).issue
    end
    
    def close_issue(repo, number)
      post("/issues/close/#{Repo.new(repo)}/#{number}").issue
    end
    
    def reopen_issue(repo, number)
      post("/issues/reopen/#{Repo.new(repo)}/#{number}").issue
    end
    
    def update_issue(repo, number, title, body)
      post("/issues/edit/#{Repo.new(repo)}/#{number}", :body => {:title => title, :body => body}).issue
    end
    
    def labels(repo)
      get("/issues/labels/#{Repo.new(repo)}").labels
    end
    
    def add_label(repo, number, label)
      post("/issues/label/add/#{Repo.new(repo)}/#{label}/#{number}").labels
    end
    
    def remove_label(repo, number, label)
      post("/issues/label/remove/#{Repo.new(repo)}/#{label}/#{number}").labels
    end

    def add_comment(repo, number, comment)
      post("/issues/comment/#{Repo.new(repo)}/#{number}", :body => {:comment => comment}).comment
    end
    
    # Repos
    
    def search_repos(q)
      q = CGI.escape(q)
      get("/repos/search/#{q}").repositories
    end
    
    def watch(repo)
      post("/repos/watch/#{Repo.new(repo)}", :query => auth_params).repository
    end
    
    def unwatch(repo)
      post("/repos/unwatch/#{Repo.new(repo)}", :query => auth_params).repository
    end
    
    def fork(repo)
      post("/repos/fork/#{Repo.new(repo)}", :query => auth_params).repository
    end
    
    # :name, :description, :homepage, :public
    def create(options)
      post("/repos/create", :query => auth_params, :body => options).repository
    end
    
    def delete(repo, delete_token={})
      repo = Repo.new(repo)
      post("/repos/delete/#{repo.name}", :query => auth_params, :body => {:delete_token => delete_token})
    end
    
    def confirm_delete(repo, delete_token)
      delete(repo, delete_token)
    end
    
    def set_private(repo)
      repo = Repo.new(repo)
      post("/repos/set/private/#{repo.name}", :query => auth_params).repository
    end
    
    def set_public(repo)
      repo = Repo.new(repo)
      post("/repos/set/public/#{repo.name}", :query => auth_params).repository
    end
    
    def deploy_keys(repo)
      repo = Repo.new(repo)
      get("/repos/keys/#{repo.name}", :query => auth_params).public_keys
    end
    
    def add_deploy_key(repo, key, title='')
      repo = Repo.new(repo)
      post("/repos/key/#{repo.name}/add", :query => auth_params, :body => {:title => title, :key => key}).public_keys
    end
    
    def remove_deploy_key(repo, id)
      repo = Repo.new(repo)
      post("/repos/key/#{repo.name}/remove", :query => auth_params, :body => {:id => id}).public_keys
    end
    
    def collaborators(repo)
      post("/repos/show/#{Repo.new(repo)}/collaborators", :query => auth_params).collaborators
    end
    
    def contributors(repo)
      get("/repos/show/#{Repo.new(repo)}/contributors").contributors
    end
    
    def repo(repo)
      get("/repos/show/#{Repo.new(repo)}", :query => auth_params).repository
    end

    # pass options without the "values[x]" descriped in the API docs:
    #    set_repo_info('user/repo', :description => "hey!", :has_wiki => false)
    def set_repo_info(repo, options)
      # post body needs to be "values[has_wiki]=false"
      response = self.class.post("/repos/show/#{Repo.new(repo)}",
        :body => options.keys.reduce({}) { |a,v| a["values[#{v}]"] = options[v]; a }.merge(auth_params))
      Hashie::Mash.new(response).repository
    end

    def list_repos(username = nil)
      if username.nil? && !@login.nil?
        username = login
      elsif username.nil?
        raise ArgumentError, 'you must provide a username'
      end
      response = self.class.get("/repos/show/#{username}", :query => auth_params)
      Hashie::Mash.new(response).repositories
    end
    
    def add_collaborator(repo, collaborator)
      repo = Repo.new(repo)
      post("/repos/collaborators/#{repo.name}/add/#{collaborator}", :query => auth_params).collaborators
    end
    
    def remove_collaborator(repo, collaborator)
      repo = Repo.new(repo)
      post("/repos/collaborators/#{repo.name}/remove/#{collaborator}", :query => auth_params).collaborators
    end
    
    def network(repo)
      get("/repos/show/#{Repo.new(repo)}/network").network
    end
    
    def languages(repo)
      get("/repos/show/#{Repo.new(repo)}/languages").languages
    end
    
    def tags(repo)
      get("/repos/show/#{Repo.new(repo)}/tags").tags
    end
    
    def branches(repo)
      get("/repos/show/#{Repo.new(repo)}/branches", :query => auth_params).branches
    end
    
    # Network
    
    def network_meta(repo)
      get("http://github.com/#{Repo.new(repo)}/network_meta")
    end
    
    def network_data(repo, nethash)
      get("http://github.com/#{Repo.new(repo)}/network_data_chunk", :query => {:nethash => nethash}).commits
    end
    
    # Trees
    
    def tree(repo, sha)
      get("http://github.com/api/v2/json/tree/show/#{Repo.new(repo)}/#{sha}", :query => auth_params).tree
    end
    
    def blob(repo, sha, path)
      get("http://github.com/api/v2/json/blob/show/#{Repo.new(repo)}/#{sha}/#{path}", :query => auth_params).blob
    end

    def raw(repo, sha)
      response = self.class.get("http://github.com/api/v2/yaml/blob/show/#{Repo.new(repo)}/#{sha}", :query => auth_params)
      response.body
    end
    
    # Commits
    
    def list_commits(repo, branch="master")
      get("http://github.com/api/v2/json/commits/list/#{Repo.new(repo)}/#{branch}").commits
    end
    
    def commit(repo, sha)
      get("http://github.com/api/v2/json/commits/show/#{Repo.new(repo)}/#{sha}").commit
    end
    
    def public_timeline(username = nil)
      username ||= @login
      if username.nil?
        path = "http://github.com/timeline.json"
      else 
        path = "http://github.com/#{username}.json"
      end
      response = self.class.get(path)
      response.map{|item| Hashie::Mash.new(item)}
    end
    
    def timeline
      response = self.class.get("http://github.com/#{@login}.private.json", :query => auth_params)
      response.map{|item| Hashie::Mash.new(item)}
    end
    
    private

    def get path, options = {}
      Hashie::Mash.new(self.class.get(path, options))
    end

    def post path, options = {}
      Hashie::Mash.new(self.class.post(path, options))
    end
    
    def auth_params
      @token.nil? ? {} : {:login => @login, :token => @token}
    end

    def self.get(*args); handle_response super end
    def self.post(*args); handle_response super end

    def self.handle_response(response)
      case response.code
      when 401; raise Unauthorized.new
      when 403; raise RateLimitExceeded.new
      when 404; raise NotFound.new
      when 400...500; raise ClientError.new
      when 500...600; raise ServerError.new(response.code)
      else; response
      end
    end
    
  end
end

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
      response = self.class.get("/user/show/#{login}", :query => auth_params)
      Hashie::Mash.new(response).user
    end
    

    def update_user(values={})
      response = self.class.post("/user/show/#{self.login}", :query => auth_params, :body => {:values => values})
      Hashie::Mash.new(response).user
    end
    
    def followers(login=self.login)
      response = self.class.get("/user/show/#{login}/followers")
      Hashie::Mash.new(response).users
    end
    
    def following(login=self.login)
      response = self.class.get("/user/show/#{login}/following")
      Hashie::Mash.new(response).users
    end
    
    def follow!(username)
      response = self.class.post("/user/follow/#{username}", :query => auth_params)
      Hashie::Mash.new(response).users
    end
    
    def unfollow!(username)
      response = self.class.post("/user/unfollow/#{username}", :query => auth_params)
      Hashie::Mash.new(response).users
    end
    
    def follows?(*args)
      target = args.pop
      username = args.first 
      username ||= self.login
      return if username.nil?
      self.following(username).include?(target)
    end
    
    def watched(login=self.login)
      response = self.class.get("/repos/watched/#{login}")
      Hashie::Mash.new(response).repositories
    end
    
    def emails
      response = self.class.get("/user/emails", :query => auth_params)
      Hashie::Mash.new(response).emails
    end
    
    def add_email(email)
      response = self.class.post("/user/email/add", :query => auth_params, :body => {:email => email})
      Hashie::Mash.new(response).emails
    end
    
    def remove_email(email)
      response = self.class.post("/user/email/remove", :query => auth_params, :body => {:email => email})
      Hashie::Mash.new(response).emails
    end
    
    def keys
      response = self.class.get("/user/keys", :query => auth_params)
      Hashie::Mash.new(response).public_keys
    end
    
    def add_key(title, key)
      response = self.class.post("/user/key/add", :query => auth_params, :body => {:title => title, :key => key})
      Hashie::Mash.new(response).public_keys
    end
    
    def remove_key(id)
      response = self.class.post("/user/key/remove", :query => auth_params, :body => {:id => id})
      Hashie::Mash.new(response).public_keys
    end

    # Issues
    
    def search_issues(repo, state, q)
      repo = Repo.new(repo)
      response = self.class.get("/issues/search/#{repo.username}/#{repo.name}/#{state}/#{q}")
      Hashie::Mash.new(response).issues
    end
    
    def issues(repo, state)
      repo = Repo.new(repo)
      response = self.class.get("/issues/list/#{repo.username}/#{repo.name}/#{state}")
      Hashie::Mash.new(response).issues
    end
    
    def issue(repo, id)
      repo = Repo.new(repo)
      response = self.class.get("/issues/show/#{repo.username}/#{repo.name}/#{id}")
      Hashie::Mash.new(response).issue
    end

    def open_issue(repo, title, body)
      repo = Repo.new(repo)
      response = self.class.post("/issues/open/#{repo.username}/#{repo.name}", :body => {:title => title, :body => body})
      Hashie::Mash.new(response).issue
    end
    
    def close_issue(repo, number)
      repo = Repo.new(repo)
      response = self.class.post("/issues/close/#{repo.username}/#{repo.name}/#{number}")
      Hashie::Mash.new(response).issue
    end
    
    def reopen_issue(repo, number)
      repo = Repo.new(repo)
      response = self.class.post("/issues/reopen/#{repo.username}/#{repo.name}/#{number}")
      Hashie::Mash.new(response).issue
    end
    
    def update_issue(repo, number, title, body)
      repo = Repo.new(repo)
      response = self.class.post("/issues/edit/#{repo.username}/#{repo.name}/#{number}", :body => {:title => title, :body => body})
      Hashie::Mash.new(response).issue
    end
    
    def labels(repo)
      repo = Repo.new(repo)
      response = self.class.get("/issues/labels/#{repo.username}/#{repo.name}")
      Hashie::Mash.new(response).labels
    end
    
    def add_label(repo, number, label)
      repo = Repo.new(repo)
      response = self.class.post("/issues/label/add/#{repo.username}/#{repo.name}/#{label}/#{number}")
      Hashie::Mash.new(response).labels
    end
    
    def remove_label(repo, number, label)
      repo = Repo.new(repo)
      response = self.class.post("/issues/label/remove/#{repo.username}/#{repo.name}/#{label}/#{number}")
      Hashie::Mash.new(response).labels
    end

    def add_comment(repo, number, comment)
      repo = Repo.new(repo)
      response = self.class.post("/issues/comment/#{repo.username}/#{repo.name}/#{number}", :body => {:comment => comment})
      Hashie::Mash.new(response).comment
    end
    
    # Repos
    
    def search_repos(q)
      q = CGI.escape(q)
      response = self.class.get("/repos/search/#{q}")
      Hashie::Mash.new(response).repositories
    end
    
    def watch(repo)
      repo = Repo.new(repo)
      response = self.class.post("/repos/watch/#{repo.username}/#{repo.name}", :query => auth_params)
      Hashie::Mash.new(response).repository
    end
    
    def unwatch(repo)
      repo = Repo.new(repo)
      response = self.class.post("/repos/unwatch/#{repo.username}/#{repo.name}", :query => auth_params)
      Hashie::Mash.new(response).repository
    end
    
    def fork(repo)
      repo = Repo.new(repo)
      response = self.class.post("/repos/fork/#{repo.username}/#{repo.name}", :query => auth_params)
      Hashie::Mash.new(response).repository
    end
    
    # :name, :description, :homepage, :public
    def create(options)
      response = self.class.post("/repos/create", :query => auth_params, :body => options)
      Hashie::Mash.new(response).repository
    end
    
    def delete(repo, delete_token={})
      repo = Repo.new(repo)
      response = self.class.post("/repos/delete/#{repo.name}", :query => auth_params, :body => {:delete_token => delete_token})
      Hashie::Mash.new(response).repository
    end
    
    def confirm_delete(repo, delete_token)
      delete(repo, delete_token)
    end
    
    def set_private(repo)
      repo = Repo.new(repo)
      response = self.class.post("/repos/set/private/#{repo.name}", :query => auth_params)
      Hashie::Mash.new(response).repository
    end
    
    def set_public(repo)
      repo = Repo.new(repo)
      response = self.class.post("/repos/set/public/#{repo.name}", :query => auth_params)
      Hashie::Mash.new(response).repository
    end
    
    def deploy_keys(repo)
      repo = Repo.new(repo)
      response = self.class.get("/repos/keys/#{repo.name}", :query => auth_params)
      Hashie::Mash.new(response).public_keys
    end
    
    def add_deploy_key(repo, key, title='')
      repo = Repo.new(repo)
      response = self.class.post("/repos/key/#{repo.name}/add", :query => auth_params, :body => {:title => title, :key => key})
      Hashie::Mash.new(response).public_keys
    end
    
    def remove_deploy_key(repo, id)
      repo = Repo.new(repo)
      response = self.class.post("/repos/key/#{repo.name}/remove", :query => auth_params, :body => {:id => id})
      Hashie::Mash.new(response).public_keys
    end
    
    def collaborators(repo)
      repo = Repo.new(repo)
      response = self.class.post("/repos/show/#{repo.username}/#{repo.name}/collaborators", :query => auth_params)
      Hashie::Mash.new(response).collaborators
    end
    
    def contributors(repo)
      repo = Repo.new(repo)
      response = self.class.get("/repos/show/#{repo.username}/#{repo.name}/contributors")
      Hashie::Mash.new(response).contributors
    end
    
    def repo(repo)
      repo = Repo.new(repo)
      response = self.class.get("/repos/show/#{repo.username}/#{repo.name}", :query => auth_params)
      Hashie::Mash.new(response).repository
    end

    # pass options without the "values[x]" descriped in the API docs:
    #    set_repo_info('user/repo', :description => "hey!", :has_wiki => false)
    def set_repo_info(repo, options)
      repo = Repo.new(repo)
      # post body needs to be "values[has_wiki]=false"
      response = self.class.post("/repos/show/#{repo.username}/#{repo.name}",
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
      response = self.class.post("/repos/collaborators/#{repo.name}/add/#{collaborator}", :query => auth_params)
      Hashie::Mash.new(response).collaborators
    end
    
    def remove_collaborator(repo, collaborator)
      repo = Repo.new(repo)
      response = self.class.post("/repos/collaborators/#{repo.name}/remove/#{collaborator}", :query => auth_params)
      Hashie::Mash.new(response).collaborators
    end
    
    def network(repo)
      repo = Repo.new(repo)
      response = self.class.get("/repos/show/#{repo.username}/#{repo.name}/network")
      Hashie::Mash.new(response).network
    end
    
    def languages(repo)
      repo = Repo.new(repo)
      response = self.class.get("/repos/show/#{repo.username}/#{repo.name}/languages")
      Hashie::Mash.new(response).languages
    end
    
    def tags(repo)
      repo = Repo.new(repo)
      response = self.class.get("/repos/show/#{repo.username}/#{repo.name}/tags")
      Hashie::Mash.new(response).tags
    end
    
    def branches(repo)
      repo = Repo.new(repo)
      response = self.class.get("/repos/show/#{repo.username}/#{repo.name}/branches", :query => auth_params)
      Hashie::Mash.new(response).branches
    end
    
    # Network
    
    def network_meta(repo)
      repo = Repo.new(repo)
      response = self.class.get("http://github.com/#{repo.username}/#{repo.name}/network_meta")
      Hashie::Mash.new(response)
    end
    
    def network_data(repo, nethash)
      repo = Repo.new(repo)
      response = self.class.get("http://github.com/#{repo.username}/#{repo.name}/network_data_chunk", :query => {:nethash => nethash})
      Hashie::Mash.new(response).commits
    end
    
    # Trees
    
    def tree(repo, sha)
      repo = Repo.new(repo)
      response = self.class.get("http://github.com/api/v2/json/tree/show/#{repo.username}/#{repo.name}/#{sha}", :query => auth_params)
      Hashie::Mash.new(response).tree
    end
    
    def blob(repo, sha, path)
      repo = Repo.new(repo)
      response = self.class.get("http://github.com/api/v2/json/blob/show/#{repo.username}/#{repo.name}/#{sha}/#{path}", :query => auth_params)
      Hashie::Mash.new(response).blob
    end

    def raw(repo, sha)
      repo = Repo.new(repo)
      response = self.class.get("http://github.com/api/v2/yaml/blob/show/#{repo.username}/#{repo.name}/#{sha}", :query => auth_params)
      response.body
    end
    
    # Commits
    
    def list_commits(repo, branch="master")
      repo = Repo.new(repo)
      response = self.class.get("http://github.com/api/v2/json/commits/list/#{repo.username}/#{repo.name}/#{branch}")
      Hashie::Mash.new(response).commits
    end
    
    def commit(repo, sha)
      repo = Repo.new(repo)
      response = self.class.get("http://github.com/api/v2/json/commits/show/#{repo.username}/#{repo.name}/#{sha}")
      Hashie::Mash.new(response).commit
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

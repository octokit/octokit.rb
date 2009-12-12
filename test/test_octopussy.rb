require 'helper'

class TestOctopussy < Test::Unit::TestCase
  
  context "when authenticated" do
    setup do
      @client = Octopussy::Client.new(:login => 'pengwynn', :token => 'OU812')
    end

    should "should search users" do
      stub_get("/user/search/wynn", "search.json")
      users = @client.search_users("wynn")
      users.first.username.should == 'pengwynn'
    end
    
    should "return full user info for the authenticated user" do
      stub_get("/user/show/pengwynn?login=pengwynn&token=OU812", "full_user.json")
      user = @client.user
      user.plan.name.should == 'free'
      user.plan.space.should == 307200
    end
    
    should "return followers for a user" do
      stub_get("/user/show/pengwynn/followers", "followers.json")
      followers = @client.followers("pengwynn")
      followers.size.should == 21
      assert followers.include?("adamstac")
    end
    
    should "return followers for the authenticated user" do
      stub_get("/user/show/pengwynn/followers", "followers.json")
      followers = @client.followers
      followers.size.should == 21
      assert followers.include?("adamstac")
    end
    
    should "return users a user follows" do
      stub_get("/user/show/pengwynn/following", "followers.json")
      followers = @client.following("pengwynn")
      followers.size.should == 21
      assert followers.include?("adamstac")
    end
    
    should "return the users the authenticated user follows" do
      stub_get("/user/show/pengwynn/following", "followers.json")
      followers = @client.following
      followers.size.should == 21
      assert followers.include?("adamstac")
    end
    
    should "return the repos a user watches" do
      stub_get("/repos/watched/pengwynn", "repos.json")
      repos = @client.watched
      repos.first.owner.should == 'jnunemaker'
      repos.first.forks.should == 120
    end
    
    should "return the repos the authenticated user watched" do
      stub_get("/repos/watched/pengwynn", "repos.json")
      repos = @client.watched('pengwynn')
      repos.first.owner.should == 'jnunemaker'
      repos.first.forks.should == 120
    end
    
    should "update user info" do
      stub_post("/user/show/pengwynn?login=pengwynn&token=OU812", "user.json")
      user = @client.update_user(:location => "Dallas, TX")
      user.location.should == 'Dallas, TX'
    end
    
    should "return emails for the authenticated user" do
      stub_get("/user/emails?login=pengwynn&token=OU812", "emails.json")
      emails = @client.emails
      emails.size.should == 3
      assert emails.include? "wynn@orrka.com"
    end
    
    should "add an email for the authenticated user" do
      stub_post("/user/email/add?login=pengwynn&token=OU812", "emails.json")
      emails = @client.add_email('wynn@orrka.com')
      emails.size.should == 3
      assert emails.include? "wynn@orrka.com"
    end
    
    should "remove an email for the authenticated user" do
      stub_post("/user/email/remove?login=pengwynn&token=OU812", "emails.json")
      emails = @client.remove_email('wynn@squeejee.com')
      emails.size.should == 3
    end
    
    should "return keys for the authenticated user" do
      stub_get("/user/keys?login=pengwynn&token=OU812", "keys.json")
      keys = @client.keys
      keys.size.should == 6
      keys.last.title.should == 'wynn@pengwynn.local'
    end
    
    should "add an key for the authenticated user" do
      stub_post("/user/key/add?login=pengwynn&token=OU812", "keys.json")
      keys = @client.add_key('pengwynn', 'ssh-rsa 009aasd0kalsdfa-sd9a-sdf')
      keys.size.should == 6
      keys.last.title.should == 'wynn@pengwynn.local'
    end
    
    should "remove an key for the authenticated user" do
      stub_post("/user/key/remove?login=pengwynn&token=OU812", "keys.json")
      keys = @client.remove_key(1234)
      keys.size.should == 6
    end
    
    should "open an issue" do
      stub_post "/issues/open/pengwynn/linkedin", "open_issue.json"
      issue = @client.open_issue(:title => "testing", :body => "Testing api", :username => "pengwynn", :repo => "linkedin")
      issue.title.should == "testing"
      issue.number.should == 2
    end
    
    should "close an issue" do
      stub_post "/issues/close/pengwynn/linkedin/2", "close_issue.json"
      issue = @client.close_issue(:number => 2, :username => "pengwynn", :repo => "linkedin")
      issue.title.should == "testing"
      issue.number.should == 2
    end
    
    should "reopen an issue" do
      stub_post "/issues/reopen/pengwynn/linkedin/2", "reopen_issue.json"
      issue = @client.close_issue(:number => 2, :username => "pengwynn", :repo => "linkedin")
      issue.title.should == "testing"
      issue.number.should == 2
    end
    
    should "edit an issue" do
      stub_post "/issues/edit/pengwynn/linkedin/2", "open_issue.json"
      issue = @client.update_issue(:title => "testing", :body => "Testing api", :username => "pengwynn", :repo => "linkedin", :number => 2)
      issue.title.should == "testing"
      issue.number.should == 2
    end
    
    should "list issue labels for a repo" do
      stub_get "/issues/labels/pengwynn/linkedin", "labels.json"
      labels = @client.labels(:username => "pengwynn", :repo => "linkedin")
      labels.first.should == 'oauth'
    end
    
    should "add a label to an issue" do
      stub_post("/issues/label/add/pengwynn/linkedin/oauth/2", "labels.json")
      labels = @client.add_label(:username => 'pengwynn', :repo => 'linkedin', :number => 2, :label => 'oauth')
      assert labels.include?("oauth")
    end
    
    should "remove a label from an issue" do
      stub_post("/issues/label/remove/pengwynn/linkedin/oauth/2", "labels.json")
      labels = @client.remove_label(:username => 'pengwynn', :repo => 'linkedin', :number => 2, :label => 'oauth')
      assert labels.is_a?(Array)
    end
    
    should "add a comment to an issue" do
      stub_post("/issues/comment/pengwynn/linkedin/2", "comment.json")
      comment = @client.add_comment(:username => 'pengwynn', :repo => 'linkedin', :number => 2, :comment => 'Nice catch!')
      comment.comment.should == 'Nice catch!'
    end
    
    should "watch a repository" do
      stub_post("/repos/watch/pengwynn/linkedin?login=pengwynn&token=OU812", "repo.json")
      repo = @client.watch('pengwynn', 'linkedin')
      repo.homepage.should == "http://bit.ly/ruby-linkedin"
    end
    
    should "unwatch a repository" do
      stub_post("/repos/unwatch/pengwynn/linkedin?login=pengwynn&token=OU812", "repo.json")
      repo = @client.unwatch('pengwynn', 'linkedin')
      repo.homepage.should == "http://bit.ly/ruby-linkedin"
    end
    
    should "fork a repository" do
      stub_post("/repos/fork/pengwynn/linkedin?login=pengwynn&token=OU812", "repo.json")
      repo = @client.fork('pengwynn', 'linkedin')
      repo.homepage.should == "http://bit.ly/ruby-linkedin"
    end
    
    should "create a repository" do
      stub_post("/repos/create?login=pengwynn&token=OU812", "repo.json")
      repo = @client.create(:name => 'linkedin', :description => 'Ruby wrapper for the LinkedIn API', :homepage => 'http://bit.ly/ruby-linkedin', :public => 1)
      repo.homepage.should == "http://bit.ly/ruby-linkedin"
    end
    
    # should "return a delete_token when calling delete without supplying a delete_token" do
    #   
    # end
    
    should "set a repo's visibility to private" do
      stub_post("/repos/set/private/linkedin?login=pengwynn&token=OU812", "repo.json")
      repo = @client.set_private('linkedin')
      repo.homepage.should == "http://bit.ly/ruby-linkedin"
    end
    
    should "set a repo's visibility to public" do
      stub_post("/repos/set/public/linkedin?login=pengwynn&token=OU812", "repo.json")
      repo = @client.set_public('linkedin')
      repo.homepage.should == "http://bit.ly/ruby-linkedin"
    end
    
    should "return deploy keys for a repo" do
      stub_get("/repos/keys/linkedin?login=pengwynn&token=OU812", "keys.json")
      keys = @client.deploy_keys('linkedin')
      keys.size.should == 6
      keys.last.title.should == 'wynn@pengwynn.local'
    end
    
    should "add a deploy key for a repo" do
      stub_post("/repos/key/linkedin/add?login=pengwynn&token=OU812", "keys.json")
      keys = @client.add_deploy_key('pengwynn', 'ssh-rsa 009aasd0kalsdfa-sd9a-sdf', 'linkedin')
      keys.size.should == 6
      keys.last.title.should == 'wynn@pengwynn.local'
    end
    
    should "remove a deploy key for a repo" do
      stub_post("/repos/key/linkedin/remove?login=pengwynn&token=OU812", "keys.json")
      keys = @client.remove_deploy_key(1234, 'linkedin')
      keys.size.should == 6
    end
    
    should "add a collaborator to a repo" do
      stub_post("/repos/collaborators/linkedin/add/adamstac?login=pengwynn&token=OU812", "collaborators.json")
      collaborators =  @client.add_collaborator(:repo => "linkedin", :collaborator => "adamstac")
      collaborators.first.should == 'pengwynn'
    end
    
    should "remove a collaborator from a repo" do
      stub_post("/repos/collaborators/linkedin/remove/adamstac?login=pengwynn&token=OU812", "collaborators.json")
      collaborators =  @client.remove_collaborator(:repo => "linkedin", :collaborator => "adamstac")
      collaborators.last.should == 'adamstac'
    end
    
    
  end
  
  
  context "when unauthenticated" do

    should "search users" do
      stub_get("/user/search/wynn", "search.json")
      users = Octopussy.search_users("wynn")
      users.first.username.should == 'pengwynn'
    end
    
    should "return user info" do
      stub_get("/user/show/pengwynn", "user.json")
      user = Octopussy.user("pengwynn")
      user.login.should == 'pengwynn'
      user.blog.should == 'http://wynnnetherland.com'
      user.name.should == 'Wynn Netherland'
    end
    
    should "return followers for a user" do
      stub_get("/user/show/pengwynn/followers", "followers.json")
      followers = Octopussy.followers("pengwynn")
      followers.size.should == 21
      assert followers.include?("adamstac")
    end
    
    should "return users a user follows" do
      stub_get("/user/show/pengwynn/following", "followers.json")
      followers = Octopussy.following("pengwynn")
      followers.size.should == 21
      assert followers.include?("adamstac")
    end
    
    should "return the repos a user watches" do
      stub_get("/repos/watched/pengwynn", "repos.json")
      repos = Octopussy.watched('pengwynn')
      repos.first.owner.should == 'jnunemaker'
      repos.first.forks.should == 120
    end
    
    should "search issues for a repo" do
      stub_get("/issues/search/jnunemaker/twitter/open/httparty", "issues.json")
      issues = Octopussy.search_issues(:username => 'jnunemaker', :repo => 'twitter', :state => 'open', :q => 'httparty')
      issues.first.title.should == 'Crack error when creating friendship'
      issues.first.votes.should == 2
    end
    
    should "list issues for a repo" do
      stub_get("/issues/list/jnunemaker/twitter/open", "issues.json")
      issues = Octopussy.issues(:username => 'jnunemaker', :repo => 'twitter', :state => 'open', :q => 'httparty')
      issues.first.title.should == 'Crack error when creating friendship'
      issues.first.votes.should == 2
    end
    
    should "return issue info" do
      stub_get("/issues/show/jnunemaker/twitter/3", "issue.json")
      issue = Octopussy.issue(:username => 'jnunemaker', :repo => 'twitter', :id => 3)
      issue.title.should == 'Crack error when creating friendship'
      issue.votes.should == 2
    end
    
    # Repos
    
    should "search repos" do
      stub_get("/repos/search/compass", "repo_search.json")
      repos = Octopussy.search_repos("compass")
      repos.first.username.should == 'chriseppstein'
      repos.first.language.should == 'Ruby'
    end
    
    should "return repo information" do
      stub_get("/repos/show/pengwynn/linkedin", "repo.json")
      repo = Octopussy.repo(:username => "pengwynn", :repo => "linkedin")
      repo.homepage.should == "http://bit.ly/ruby-linkedin"
    end
    
    should "list repos for a user" do
      stub_get("/repos/show/pengwynn", "repos.json")
      repos = Octopussy.list_repos('pengwynn')
      repos.first.name.should == 'twitter'
      repos.first.watchers.should == 609
    end
    
    should "list collaborators for a repo" do
      stub_post("/repos/show/pengwynn/octopussy/collaborators", "collaborators.json")
      users = Octopussy.collaborators(:username => "pengwynn", :repo => "octopussy")
      users.last.should == 'adamstac'
    end
    
    should "show the network for a repo" do
      stub_get("/repos/show/pengwynn/linkedin/network", "network.json")
      network = Octopussy.network(:username => 'pengwynn', :repo => "linkedin")
      network.last.owner.should == 'nfo'
    end
    
    should "show the language breakdown for a repo" do
      stub_get("/repos/show/pengwynn/linkedin/languages", "languages.json")
      languages = Octopussy.languages(:username => 'pengwynn', :repo => "linkedin")
      languages['Ruby'].should == 21515
    end
    
    should "list all the tags in a repo" do
      stub_get("/repos/show/pengwynn/linkedin/tags", "tags.json")
      tags = Octopussy.tags(:username => 'pengwynn', :repo => "linkedin")
      assert tags.include?("v0.0.1")
    end
    
    should "list all the branches in a repo" do
      stub_get("/repos/show/pengwynn/linkedin/branches", "branches.json")
      branches = Octopussy.branches(:username => 'pengwynn', :repo => "linkedin")
      assert branches.include?("integration")
    end
  
    
    # network
    should "return network meta info for a repo" do
      stub_get("http://github.com/schacon/simplegit/network_meta", "network_meta.json")
      info = Octopussy.network_meta(:username => "schacon", :repo => "simplegit")
      info.users.first.name.should == 'schacon'
      info.users.first.repo.should == 'simplegit'
    end
    
    should "return first 100 commits by branch" do
      stub_get("http://github.com/schacon/simplegit/network_data_chunk?nethash=fa8fe264b926cdebaab36420b6501bd74402a6ff", "network_data.json")
      info = Octopussy.network_data(:username => "schacon", :repo => "simplegit", :nethash => "fa8fe264b926cdebaab36420b6501bd74402a6ff")
      assert info.is_a?(Array)
    end
    
  end
  
end

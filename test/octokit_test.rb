require File.expand_path(File.dirname(__FILE__) + '/helper')

class OctokitTest < Test::Unit::TestCase

  context "when oauthed" do
    setup do
      @client = Octokit::Client.new(:login => 'pengwynn', :oauth_token => 'OU812')
    end
    should "return full user info for the authenticated user" do
      stub_get("user/show", "full_user.json")
      user = @client.user
      user.plan.name.should == 'free'
      user.plan.space.should == 307200
    end
  end

  context "when authenticated" do
    setup do
      @client = Octokit::Client.new(:login => 'pengwynn', :token => 'OU812')
    end

    should "should search users by username" do
      stub_get("user/search/wynn", "search-username.json")
      users = @client.search_users("wynn")
      users.first.username.should == 'pengwynn'
    end
    
    should "should search users by email" do
      stub_get("user/email/wynn.netherland@gmail.com", "search-email.json")
      users = @client.search_users("wynn.netherland@gmail.com")
      users.login.should == 'pengwynn'
    end

    should "return full user info for the authenticated user" do
      stub_get("user/show", "full_user.json")
      user = @client.user
      user.plan.name.should == 'free'
      user.plan.space.should == 307200
    end

    should "return followers for a user" do
      stub_get("user/show/pengwynn/followers", "followers.json")
      followers = @client.followers("pengwynn")
      followers.size.should == 21
      assert followers.include?("adamstac")
    end

    should "return followers for the authenticated user" do
      stub_get("user/show/pengwynn/followers", "followers.json")
      followers = @client.followers
      followers.size.should == 21
      assert followers.include?("adamstac")
    end

    should "return users a user follows" do
      stub_get("user/show/pengwynn/following", "followers.json")
      followers = @client.following("pengwynn")
      followers.size.should == 21
      assert followers.include?("adamstac")
    end

    should "return the users the authenticated user follows" do
      stub_get("user/show/pengwynn/following", "followers.json")
      followers = @client.following
      followers.size.should == 21
      assert followers.include?("adamstac")
    end

    should "indicate if one user follows another" do
      stub_get("user/show/pengwynn/following", "followers.json")
      @client.follows?('adamstac')
    end

    should "return the repos a user watches" do
      stub_get("repos/watched/pengwynn", "repos.json")
      repos = @client.watched
      repos.first.owner.should == 'jnunemaker'
      repos.first.forks.should == 120
    end

    should "return the repos the authenticated user watched" do
      stub_get("repos/watched/pengwynn", "repos.json")
      repos = @client.watched('pengwynn')
      repos.first.owner.should == 'jnunemaker'
      repos.first.forks.should == 120
    end

    should "update user info" do
      stub_post("user/show/pengwynn", "user.json")
      user = @client.update_user(:location => "Dallas, TX")
      user.location.should == 'Dallas, TX'
    end

    should "return emails for the authenticated user" do
      stub_get("user/emails", "emails.json")
      emails = @client.emails
      emails.size.should == 3
      assert emails.include? "wynn@orrka.com"
    end

    should "add an email for the authenticated user" do
      stub_post("user/email/add", "emails.json")
      emails = @client.add_email('wynn@orrka.com')
      emails.size.should == 3
      assert emails.include? "wynn@orrka.com"
    end

    should "remove an email for the authenticated user" do
      stub_post("user/email/remove", "emails.json")
      emails = @client.remove_email('wynn@squeejee.com')
      emails.size.should == 3
    end

    should "return keys for the authenticated user" do
      stub_get("user/keys", "keys.json")
      keys = @client.keys
      keys.size.should == 6
      keys.last.title.should == 'wynn@pengwynn.local'
    end

    should "add an key for the authenticated user" do
      stub_post("user/key/add", "keys.json")
      keys = @client.add_key('pengwynn', 'ssh-rsa 009aasd0kalsdfa-sd9a-sdf')
      keys.size.should == 6
      keys.last.title.should == 'wynn@pengwynn.local'
    end

    should "remove an key for the authenticated user" do
      stub_post("user/key/remove", "keys.json")
      keys = @client.remove_key(1234)
      keys.size.should == 6
    end

    should "open an issue" do
      stub_post("issues/open/pengwynn/linkedin", "open_issue.json")
      issue = @client.open_issue({:username => "pengwynn", :repo => "linkedin"}, "testing", "Testing api")
      issue.title.should == "testing"
      issue.number.should == 2
    end

    should "close an issue" do
      stub_post("issues/close/pengwynn/linkedin/2", "close_issue.json")
      issue = @client.close_issue({:username => "pengwynn", :repo => "linkedin"}, 2)
      issue.title.should == "testing"
      issue.number.should == 2
    end

    should "reopen an issue" do
      stub_post("issues/reopen/pengwynn/linkedin/2", "reopen_issue.json")
      issue = @client.close_issue({:username => "pengwynn", :repo => "linkedin"}, 2)
      issue.title.should == "testing"
      issue.number.should == 2
    end

    should "edit an issue" do
      stub_post("issues/edit/pengwynn/linkedin/2", "open_issue.json")
      issue = @client.update_issue("pengwynn/linkedin", 2, "testing", "Testing api")
      issue.title.should == "testing"
      issue.number.should == 2
    end

    should "list issue labels for a repo" do
      stub_get("issues/labels/pengwynn/linkedin", "labels.json")
      labels = @client.labels("pengwynn/linkedin")
      labels.first.should == 'oauth'
    end

    should "add a label to an issue" do
      stub_post("issues/label/add/pengwynn/linkedin/oauth/2", "labels.json")
      labels = @client.add_label('pengwynn/linkedin', 2, 'oauth')
      assert labels.include?("oauth")
    end

    should "remove a label from an issue" do
      stub_post("issues/label/remove/pengwynn/linkedin/oauth/2", "labels.json")
      labels = @client.remove_label('pengwynn/linkedin', 2, 'oauth')
      assert labels.is_a?(Array)
    end

    should "add a comment to an issue" do
      stub_post("issues/comment/pengwynn/linkedin/2", "comment.json")
      comment = @client.add_comment('pengwynn/linkedin', 2, 'Nice catch!')
      comment.comment.should == 'Nice catch!'
    end

    should "watch a repository" do
      stub_post("repos/watch/pengwynn/linkedin", "repo.json")
      repo = @client.watch('pengwynn/linkedin')
      repo.homepage.should == "http://bit.ly/ruby-linkedin"
    end

    should "unwatch a repository" do
      stub_post("repos/unwatch/pengwynn/linkedin", "repo.json")
      repo = @client.unwatch('pengwynn/linkedin')
      repo.homepage.should == "http://bit.ly/ruby-linkedin"
    end

    should "fork a repository" do
      stub_post("repos/fork/pengwynn/linkedin", "repo.json")
      repo = @client.fork('pengwynn/linkedin')
      repo.homepage.should == "http://bit.ly/ruby-linkedin"
    end

    should "create a repository" do
      stub_post("repos/create", "repo.json")
      repo = @client.create(:name => 'linkedin', :description => 'Ruby wrapper for the LinkedIn API', :homepage => 'http://bit.ly/ruby-linkedin', :public => 1)
      repo.homepage.should == "http://bit.ly/ruby-linkedin"
    end

    # should "return a delete_token when calling delete without supplying a delete_token" do
    #
    # end

    should "set a repo's visibility to private" do
      stub_post("repos/set/private/linkedin", "repo.json")
      repo = @client.set_private('linkedin')
      repo.homepage.should == "http://bit.ly/ruby-linkedin"
    end

    should "set a repo's visibility to public" do
      stub_post("repos/set/public/linkedin", "repo.json")
      repo = @client.set_public('linkedin')
      repo.homepage.should == "http://bit.ly/ruby-linkedin"
    end

    should "return deploy keys for a repo" do
      stub_get("repos/keys/linkedin", "keys.json")
      keys = @client.deploy_keys('linkedin')
      keys.size.should == 6
      keys.last.title.should == 'wynn@pengwynn.local'
    end

    should "add a deploy key for a repo" do
      stub_post("repos/key/pengwynn/linkedin/add", "keys.json")
      keys = @client.add_deploy_key('pengwynn/linkedin', 'ssh-rsa 009aasd0kalsdfa-sd9a-sdf')
      keys.size.should == 6
      keys.last.title.should == 'wynn@pengwynn.local'
    end

    should "remove a deploy key for a repo" do
      stub_post("repos/key/pengwynn/linkedin/remove", "keys.json")
      keys = @client.remove_deploy_key('pengwynn/linkedin', 1234)
      keys.size.should == 6
    end

    should "add a collaborator to a repo" do
      stub_post("repos/collaborators/linkedin/add/adamstac", "collaborators.json")
      collaborators =  @client.add_collaborator("linkedin", "adamstac")
      collaborators.first.should == 'pengwynn'
    end

    should "remove a collaborator from a repo" do
      stub_post("repos/collaborators/linkedin/remove/adamstac", "collaborators.json")
      collaborators =  @client.remove_collaborator("linkedin", "adamstac")
      collaborators.last.should == 'adamstac'
    end

    should "fetch a user's public timeline" do
      stub_get("https://pengwynn%2Ftoken:OU812@github.com/pengwynn.json", "timeline.json")
      events = @client.public_timeline('pengwynn')
      events.first['type'].should == 'FollowEvent'
      events[1].repository.name.should == 'octokit'
    end

    should "fetch a user's private timeline" do
      stub_get("https://pengwynn%2Ftoken:OU812@github.com/pengwynn.private.json", "timeline.json")
      events = @client.timeline
      events.first['type'].should == 'FollowEvent'
      events[1].repository.name.should == 'octokit'
    end
  end


  context "when unauthenticated" do

    should "search users" do
      stub_get("user/search/wynn", "search-username.json")
      users = Octokit.search_users("wynn")
      users.first.username.should == 'pengwynn'
    end
    
    should "should search users by email" do
      stub_get("user/email/wynn.netherland@gmail.com", "search-email.json")
      users = Octokit.search_users("wynn.netherland@gmail.com")
      users.login.should == 'pengwynn'
    end

    should "return user info" do
      stub_get("user/show/pengwynn", "user.json")
      user = Octokit.user("pengwynn")
      user.login.should == 'pengwynn'
      user.blog.should == 'http://wynnnetherland.com'
      user.name.should == 'Wynn Netherland'
    end

    should "return followers for a user" do
      stub_get("user/show/pengwynn/followers", "followers.json")
      followers = Octokit.followers("pengwynn")
      followers.size.should == 21
      assert followers.include?("adamstac")
    end

    should "indicate if one user follows another" do
      stub_get("user/show/pengwynn/following", "followers.json")
      assert Octokit.follows?('pengwynn', 'adamstac')
    end

    should "return users a user follows" do
      stub_get("user/show/pengwynn/following", "followers.json")
      followers = Octokit.following("pengwynn")
      followers.size.should == 21
      assert followers.include?("adamstac")
    end

    should "return the repos a user watches" do
      stub_get("repos/watched/pengwynn", "repos.json")
      repos = Octokit.watched('pengwynn')
      repos.first.owner.should == 'jnunemaker'
      repos.first.forks.should == 120
    end

    should "search issues for a repo" do
      stub_get("issues/search/jnunemaker/twitter/open/httparty", "issues.json")
      issues = Octokit.search_issues({:username => 'jnunemaker', :repo => 'twitter'}, 'httparty')
      issues.first.title.should == 'Crack error when creating friendship'
      issues.first.votes.should == 2
    end

    should "list issues for a repo" do
      stub_get("issues/list/jnunemaker/twitter/open", "issues.json")
      issues = Octokit.issues({:username => 'jnunemaker', :repo => 'twitter'}, 'open')
      issues.first.title.should == 'Crack error when creating friendship'
      issues.first.votes.should == 2
    end

    should "return issue info" do
      stub_get("issues/show/jnunemaker/twitter/3", "issue.json")
      issue = Octokit.issue({:username => 'jnunemaker', :repo => 'twitter'}, 3)
      issue.title.should == 'Crack error when creating friendship'
      issue.votes.should == 2
    end

    # Repos

    should "search repos" do
      stub_get("repos/search/compass", "repo_search.json")
      repos = Octokit.search_repos("compass")
      repos.first.username.should == 'chriseppstein'
      repos.first.language.should == 'Ruby'
    end

    should "return repo information" do
      stub_get("repos/show/pengwynn/linkedin", "repo.json")
      repo = Octokit.repo({:username => "pengwynn", :repo => "linkedin"})
      repo.homepage.should == "http://bit.ly/ruby-linkedin"
    end

    should "return a repo's contributors list" do
      stub_get("repos/show/pengwynn/linkedin/contributors", "contributors.json")
      contributors_list = Octokit.contributors({:username => "pengwynn", :repo => "linkedin"})
      assert contributors_list.include?(["holman", 1])
    end

    should "list repos for a user" do
      stub_get("repos/show/pengwynn", "repos.json")
      repos = Octokit.list_repos('pengwynn')
      repos.first.name.should == 'twitter'
      repos.first.watchers.should == 609
    end

    should "list collaborators for a repo" do
      stub_get("repos/show/pengwynn/octokit/collaborators", "collaborators.json")
      users = Octokit.collaborators({:username => "pengwynn", :repo => "octokit"})
      users.last.should == 'adamstac'
    end

    should "show the network for a repo" do
      stub_get("repos/show/pengwynn/linkedin/network", "network.json")
      network = Octokit.network({:username => 'pengwynn', :repo => "linkedin"})
      network.last.owner.should == 'nfo'
    end

    should "show the language breakdown for a repo" do
      stub_get("repos/show/pengwynn/linkedin/languages", "languages.json")
      languages = Octokit.languages({:username => 'pengwynn', :repo => "linkedin"})
      languages['Ruby'].should == 21515
    end

    should "list all the tags in a repo" do
      stub_get("repos/show/pengwynn/linkedin/tags", "tags.json")
      tags = Octokit.tags(:username => 'pengwynn', :repo => "linkedin")
      assert tags.include?("v0.0.1")
    end

    should "list all the branches in a repo" do
      stub_get("repos/show/pengwynn/linkedin/branches", "branches.json")
      branches = Octokit.branches(:username => 'pengwynn', :repo => "linkedin")
      assert branches.include?("integration")
    end

    # network
    should "return network meta info for a repo" do
      stub_get("https://github.com/schacon/simplegit/network_meta", "network_meta.json")
      info = Octokit.network_meta(:username => "schacon", :repo => "simplegit")
      info.users.first.name.should == 'schacon'
      info.users.first.repo.should == 'simplegit'
    end

    should "return first 100 commits by branch" do
      stub_get("https://github.com/schacon/simplegit/network_data_chunk?nethash=fa8fe264b926cdebaab36420b6501bd74402a6ff", "network_data.json")
      info = Octokit.network_data({:username => "schacon", :repo => "simplegit"}, "fa8fe264b926cdebaab36420b6501bd74402a6ff")
      assert info.is_a?(Array)
    end

    # trees
    should "return contents of a tree by tree SHA" do
      stub_get("tree/show/defunkt/facebox/a47803c9ba26213ff194f042ab686a7749b17476", "trees.json")
      trees = Octokit.tree({:username => "defunkt", :repo => "facebox"}, "a47803c9ba26213ff194f042ab686a7749b17476")
      trees.first.name.should == '.gitignore'
      trees.first.sha.should == 'e43b0f988953ae3a84b00331d0ccf5f7d51cb3cf'
    end

    should "return data about a blob by tree SHA and path" do
      stub_get("blob/show/defunkt/facebox/d4fc2d5e810d9b4bc1ce67702603080e3086a4ed/README.txt", "blob.json")
      blob = Octokit.blob({:username => "defunkt", :repo => "facebox"}, "d4fc2d5e810d9b4bc1ce67702603080e3086a4ed", "README.txt")
      blob.name.should == 'README.txt'
      blob.sha.should == 'd4fc2d5e810d9b4bc1ce67702603080e3086a4ed'
    end

    should "return the contents of a blob with the blob's SHA" do
      begin
        Octokit.format = :yaml
        stub_get("blob/show/defunkt/facebox/4bf7a39e8c4ec54f8b4cd594a3616d69004aba69", "raw_git_data.yaml")
        raw_text = Octokit.raw({:username => "defunkt", :repo => "facebox"}, "4bf7a39e8c4ec54f8b4cd594a3616d69004aba69")
      ensure
        Octokit.format = :json
      end
      assert raw_text.include?("cd13d9a61288dceb0a7aa73b55ed2fd019f4f1f7")
    end

    #commits
    should "list commits for a repo's master branch by default" do
      stub_get("commits/list/defunkt/facebox/master", "commits.json")
      commits_list = Octokit.list_commits({:username => "defunkt", :repo => "facebox"})
      assert commits_list.any? { |c| c.message == "Fixed CSS expression, throwing errors in IE6." }
    end

    should "list commits for a repo on a given branch" do
      stub_get("commits/list/schacon/simplegit/m/dev/cp", "branch_commits.json")
      commits_list = Octokit.list_commits({:username => "schacon", :repo => "simplegit"}, "m/dev/cp")
      assert commits_list.any? { |c| c.message == "removed unnecessary test code" }
    end

    should "show a specific commit for a repo given its SHA" do
      sha = "1ff368f79b0f0aa0e1f1d78bcaa8691f94f9703e"
      stub_get("commits/show/defunkt/facebox/#{sha}", "show_commit.json")
      show_commit = Octokit.commit({:username => "defunkt", :repo => "facebox"}, sha)
      assert show_commit.message == "Fixed CSS expression, throwing errors in IE6."
    end

    #timeline

    should "fetch the public timeline" do
      stub_get("https://github.com/timeline.json", "timeline.json")
      events = Octokit.public_timeline
      events.first['type'].should == 'FollowEvent'
      events[1].repository.name.should == 'octokit'
    end

    should "fetch a user's public timeline" do
      stub_get("https://github.com/pengwynn.json", "timeline.json")
      events = Octokit.public_timeline('pengwynn')
      events.first['type'].should == 'FollowEvent'
      events[1].repository.name.should == 'octokit'
    end

  end

  context "when Github responds with an error" do
    {
      ["400", "BadRequest"]          => Octokit::BadRequest,
      ["401", "Unauthorized"]        => Octokit::Unauthorized,
      ["403", "Forbidden"]           => Octokit::Forbidden,
      ["404", "NotFound"]            => Octokit::NotFound,
      ["406", "NotAcceptable"]       => Octokit::NotAcceptable,
      ["500", "InternalServerError"] => Octokit::InternalServerError,
      ["501", "NotImplemented"]      => Octokit::NotImplemented,
      ["502", "BadGateway"]          => Octokit::BadGateway,
      ["503", "ServiceUnavailable"]  => Octokit::ServiceUnavailable,
    }.each do |status, exception|
      context "#{status.first}, a get" do
        should "raise an #{exception.name} error" do
          stub_get("user/show/pengwynn", nil, status)
          lambda { Octokit.user("pengwynn") }.should raise_error(exception)
        end
      end

      context "#{status.first}, a post" do
        should "raise an #{exception.name} error" do
          @client = Octokit::Client.new(:login => 'pengwynn', :token => 'OU812')
          stub_post("user/show/pengwynn", nil, status)
          lambda { @client.update_user(:location => "Dallas, TX") }.should raise_error(exception)
        end
      end
    end
  end

  context "when consuming feeds" do

    should "should set user, title, and published time for the event" do
      entry = Hashie::Mash.new({
        :id => 'tag:github.com,2008:CreateEvent/110645788',
        :published => '2009-12-12T11:24:14-08:00',
        :updated => '2009-12-12T11:24:14-08:00',
        :links => ['http://github.com/jnunemaker/twitter/tree/v0.7.10'],
        :title => 'pengwynn created tag v0.7.10 at jnunemaker/twitter',
        :author => 'pengwynn'
      })

      event = Octokit::Event.load_from_atom(entry)
      event.user.should == 'pengwynn'
      event.published.year.should == 2009
      event.published.month.should == 12
      event.id.should == 110645788
      event.title.should == 'pengwynn created tag v0.7.10 at jnunemaker/twitter'
      event.links.first.should == 'http://github.com/jnunemaker/twitter/tree/v0.7.10'
    end

    should "should create a repo event from an atom entry" do
      entry = Hashie::Mash.new({
        :id => 'tag:github.com,2008:CreateEvent/110645788',
        :published => '2009-12-12T11:24:14-08:00',
        :updated => '2009-12-12T11:24:14-08:00',
        :links => ['http://github.com/Tanner/Team-1261---Java'],
        :title => 'Tanner created repository Team-1261---Java',
        :author => 'Tanner'
      })

      event = Octokit::Event.load_from_atom(entry)
      event.event_type.should == 'repo'
      event.repo.username.should == 'Tanner'
      event.repo.name.should == 'Team-1261---Java'
    end

    should "should create a tag event from an atom entry" do
      entry = Hashie::Mash.new({
        :id => 'tag:github.com,2008:CreateEvent/110645788',
        :published => '2009-12-12T11:24:14-08:00',
        :updated => '2009-12-12T11:24:14-08:00',
        :links => ['http://github.com/jnunemaker/twitter/tree/v0.7.10'],
        :title => 'pengwynn created tag v0.7.10 at jnunemaker/twitter',
        :author => 'pengwynn'
      })

      event = Octokit::Event.load_from_atom(entry)
      event.event_type.should == 'tag'
      event.repo.username.should == 'jnunemaker'
      event.repo.name.should == 'twitter'
      event.tag.should == 'v0.7.10'
    end

    should "should create a branch event from an atom entry" do
      entry = Hashie::Mash.new({
        :id => 'tag:github.com,2008:CreateEvent/110645788',
        :published => '2009-12-12T11:24:14-08:00',
        :updated => '2009-12-12T11:24:14-08:00',
        :links => ['http://github.com/Fabi/cwcore/tree/cwcore-0.1'],
        :title => 'cwcore created branch cwcore-0.1 at Fabi/cwcore',
        :author => 'cwcore'
      })

      event = Octokit::Event.load_from_atom(entry)
      event.event_type.should == 'branch'
      event.repo.username.should == 'Fabi'
      event.repo.name.should == 'cwcore'
      event.user.should == 'cwcore'
      event.branch.should == 'cwcore-0.1'
    end

    should "should create a push event from an atom entry" do
      entry = Hashie::Mash.new({
        :id => 'tag:github.com,2008:PushEvent/110645788',
        :published => '2009-12-12T11:24:14-08:00',
        :updated => '2009-12-12T11:24:14-08:00',
        :links => ['http://github.com/jnunemaker/twitter/commits/master'],
        :title => 'pengwynn pushed to master at jnunemaker/twitter',
        :author => 'pengwynn'
      })

      event = Octokit::Event.load_from_atom(entry)
      event.event_type.should == 'push'
      event.repo.name.should == 'twitter'
      event.branch.should == 'master'
    end

    should "should create a fork event from an atom entry" do
      entry = Hashie::Mash.new({
        :id => 'tag:github.com,2008:ForkEvent/110645788',
        :published => '2009-12-12T11:24:14-08:00',
        :updated => '2009-12-12T11:24:14-08:00',
        :links => ['http://github.com/klauge/aeon/'],
        :title => 'klauge forked djh/aeon',
        :author => 'klauge'
      })

      event = Octokit::Event.load_from_atom(entry)
      event.event_type.should == 'fork'
      event.repo.username.should == 'klauge'
      event.repo.name.should == 'aeon'
      event.forked_from.username.should == 'djh'
    end

    should "should create a watch event from an atom entry" do
      entry = Hashie::Mash.new({
        :id => 'tag:github.com,2008:WatchEvent/110645788',
        :published => '2009-12-12T11:24:14-08:00',
        :updated => '2009-12-12T11:24:14-08:00',
        :links => ['http://github.com/bogolisk/egg'],
        :title => 'jpablobr started watching bogolisk/egg',
        :author => 'jpablobr'
      })

      event = Octokit::Event.load_from_atom(entry)
      event.event_type.should == 'watch'
      event.repo.username.should == 'bogolisk'
      event.repo.name.should == 'egg'
    end

    should "should create a follow event from an atom entry" do
      entry = Hashie::Mash.new({
        :id => 'tag:github.com,2008:FollowEvent/110645788',
        :published => '2009-12-12T11:24:14-08:00',
        :updated => '2009-12-12T11:24:14-08:00',
        :links => ['http://github.com/swistak'],
        :title => 'pengwynn started following swistak',
        :author => 'pengwynn'
      })

      event = Octokit::Event.load_from_atom(entry)
      event.event_type.should == 'follow'
      event.repo.should == nil
      event.target_user.should == 'swistak'
    end

    should "should create an issues event from an atom entry" do
      entry = Hashie::Mash.new({
        :id => 'tag:github.com,2008:IssuesEvent/110645788',
        :published => '2009-12-12T11:24:14-08:00',
        :updated => '2009-12-12T11:24:14-08:00',
        :links => ['http://github.com/jnunemaker/twitter/issues/19/find'],
        :title => 'pengwynn closed issue 19 on jnunemaker/twitter',
        :author => 'pengwynn'
      })

      event = Octokit::Event.load_from_atom(entry)
      event.event_type.should == 'issue'
      event.repo.name.should == 'twitter'
      event.action.should == 'closed'
      event.issue_number.should == 19
    end

    should "should create a gist event from an atom entry" do
      entry = Hashie::Mash.new({
        :id => 'tag:github.com,2008:GistEvent/110645788',
        :published => '2009-12-12T11:24:14-08:00',
        :updated => '2009-12-12T11:24:14-08:00',
        :links => ['http://gist.github.com/253987'],
        :title => 'pengwynn created gist: 253987',
        :author => 'pengwynn'
      })

      event = Octokit::Event.load_from_atom(entry)
      event.event_type.should == 'gist'
      event.repo.should == nil
      event.gist_number.should == 253987
    end

    should "should create a member event from an atom entry" do
      entry = Hashie::Mash.new({
        :id => 'tag:github.com,2008:MemberEvent/110645788',
        :published => '2009-12-12T11:24:14-08:00',
        :updated => '2009-12-12T11:24:14-08:00',
        :links => ['http://github.com/pengwynn/octokit'],
        :title => 'pengwynn added adamstac to octokit',
        :author => 'pengwynn'
      })

      event = Octokit::Event.load_from_atom(entry)
      event.event_type.should == 'member'
      event.repo.name.should == 'octokit'
      event.target_user.should == 'adamstac'
    end

    should "should create a fork_apply event from an atom entry" do
      entry = Hashie::Mash.new({
        :id => 'tag:github.com,2008:ForkApplyEvent/110645788',
        :published => '2009-12-12T11:24:14-08:00',
        :updated => '2009-12-12T11:24:14-08:00',
        :links => ['http://github.com/pengwynn/linkedin/tree/integration'],
        :title => 'pengwynn applied fork commits to linkedin/integration',
        :author => 'pengwynn'
      })

      event = Octokit::Event.load_from_atom(entry)
      event.event_type.should == 'fork_apply'
      event.repo.name.should == 'linkedin'
      event.branch.should == 'integration'
    end

    should "should create a wiki event from an atom entry" do
      entry = Hashie::Mash.new({
        :id => 'tag:github.com,2008:WikiEvent/110645788',
        :published => '2009-12-12T11:24:14-08:00',
        :updated => '2009-12-12T11:24:14-08:00',
        :links => ['http://github.com/dxw/Fammel/wikis/documentation'],
        :title => 'dxw edited a page in the dxw/Fammel wiki',
        :author => 'dxw'
      })

      event = Octokit::Event.load_from_atom(entry)
      event.event_type.should == 'wiki'
      event.repo.name.should == 'Fammel'
      event.page.should == 'documentation'
    end

    should "should create a comment event from an atom entry" do
      entry = Hashie::Mash.new({
        :id => 'tag:github.com,2008:CommitCommentEvent/110645788',
        :published => '2009-12-12T11:24:14-08:00',
        :updated => '2009-12-12T11:24:14-08:00',
        :links => ['http://github.com/fakechris/resque/commit/46f7ff1f73ae16ca8060fa3b051900562b51d5c2#-P0'],
        :title => 'defunkt commented on fakechris/resque',
        :author => 'defunkt'
      })

      event = Octokit::Event.load_from_atom(entry)
      event.event_type.should == 'comment'
      event.repo.name.should == 'resque'
    end

    should "should create a delete event from an atom entry" do
      entry = Hashie::Mash.new({
        :id => 'tag:github.com,2008:DeleteEvent/110645788',
        :published => '2009-12-12T11:24:14-08:00',
        :updated => '2009-12-12T11:24:14-08:00',
        :links => ['http://github.com/jinzhu'],
        :title => 'jinzhu deleted branch search at jinzhu/vimlike-smooziee',
        :author => 'jinzhu'
      })

      event = Octokit::Event.load_from_atom(entry)
      event.event_type.should == 'delete'
      event.repo.name.should == 'vimlike-smooziee'
      event.branch.should == 'search'
    end

    should "should create a public event from an atom entry" do
      entry = Hashie::Mash.new({
        :id => 'tag:github.com,2008:PublicEvent/110645788',
        :published => '2009-12-12T11:24:14-08:00',
        :updated => '2009-12-12T11:24:14-08:00',
        :links => ['http://github.com/intalio'],
        :title => 'intalio open sourced bpmn2',
        :author => 'intalio'
      })

      event = Octokit::Event.load_from_atom(entry)
      event.event_type.should == 'public'
      event.repo.name.should == 'bpmn2'
    end

    should "should create a download event from an atom entry" do
      entry = Hashie::Mash.new({
        :id => 'tag:github.com,2008:DownloadEvent/110645788',
        :published => '2009-12-12T11:24:14-08:00',
        :updated => '2009-12-12T11:24:14-08:00',
        :links => ['http://github.com/tobie'],
        :title => 'tobie uploaded a file to sstephenson/prototype',
        :author => 'tobie'
      })

      event = Octokit::Event.load_from_atom(entry)
      event.event_type.should == 'download'
      event.repo.name.should == 'prototype'
    end

  end

end

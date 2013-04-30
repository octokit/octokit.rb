
  describe ".list_commit_comments" do

    it "returns a list of all commit comments" do
      stub_get("/repos/sferik/rails_admin/comments").
        to_return(json_response("list_commit_comments.json"))
      commit_comments = @client.list_commit_comments("sferik/rails_admin")
      expect(commit_comments.first.user.login).to eq("sferik")
    end

  end

  describe ".commit_comments" do

    it "returns a list of comments for a specific commit" do
      stub_get("/repos/sferik/rails_admin/commits/629e9fd9d4df25528e84d31afdc8ebeb0f56fbb3/comments").
        to_return(json_response("commit_comments.json"))
      commit_comments = @client.commit_comments("sferik/rails_admin", "629e9fd9d4df25528e84d31afdc8ebeb0f56fbb3")
      expect(commit_comments.first.user.login).to eq("bbenezech")
    end

  end

  describe ".commit_comment" do

    it "returns a single commit comment" do
      stub_get("/repos/sferik/rails_admin/comments/861907").
        to_return(json_response("commit_comment.json"))
      commit = @client.commit_comment("sferik/rails_admin", "861907")
      expect(commit.user.login).to eq("bbenezech")
    end

  end

  describe ".create_commit_comment" do

    it "creates a commit comment" do
      stub_post("/repos/sferik/rails_admin/commits/629e9fd9d4df25528e84d31afdc8ebeb0f56fbb3/comments").
        with(:body => { :body => "Hey Eric,\r\n\r\nI think it's a terrible idea: for a number of reasons (dissections, etc.), test suite should stay deterministic IMO.\r\n", :commit_id => "629e9fd9d4df25528e84d31afdc8ebeb0f56fbb3", :line => 1, :path => ".rspec", :position => 4 },
             :headers => { "Content-Type" => "application/json" }).
        to_return(json_response("commit_comment_create.json"))
      commit_comment = @client.create_commit_comment("sferik/rails_admin", "629e9fd9d4df25528e84d31afdc8ebeb0f56fbb3", "Hey Eric,\r\n\r\nI think it's a terrible idea: for a number of reasons (dissections, etc.), test suite should stay deterministic IMO.\r\n", ".rspec", 1, 4)
      expect(commit_comment.body).to eq("Hey Eric,\r\n\r\nI think it's a terrible idea: for a number of reasons (dissections, etc.), test suite should stay deterministic IMO.\r\n")
      expect(commit_comment.commit_id).to eq("629e9fd9d4df25528e84d31afdc8ebeb0f56fbb3")
      expect(commit_comment.path).to eq(".rspec")
      expect(commit_comment.line).to eq(1)
      expect(commit_comment.position).to eq(4)
    end

  end

  describe ".update_commit_comment" do

    it "updates a commit comment" do
      stub_patch("/repos/sferik/rails_admin/comments/860296").
        with(:body => { :body => "Hey Eric,\r\n\r\nI think it's a terrible idea. The test suite should stay deterministic IMO.\r\n" },
          :headers => { "Content-Type" => "application/json" }).
        to_return(json_response("commit_comment_update.json"))
        commit_comment = @client.update_commit_comment("sferik/rails_admin", "860296", "Hey Eric,\r\n\r\nI think it's a terrible idea. The test suite should stay deterministic IMO.\r\n")
        expect(commit_comment.body).to eq("Hey Eric,\r\n\r\nI think it's a terrible idea. The test suite should stay deterministic IMO.\r\n")
    end

  end

  describe ".delete_commit_comment" do

    it "deletes a commit comment" do
      stub_delete("/repos/sferik/rails_admin/comments/860296").
        to_return(:status => 204, :body => "")
      commit_comment = @client.delete_commit_comment("sferik/rails_admin", "860296")
      expect(commit_comment).to eq(true)
    end

  end

  describe ".compare" do

    it "returns a comparison" do
      stub_get("/repos/gvaughn/octokit/compare/0e0d7ae299514da692eb1cab741562c253d44188...b7b37f75a80b8e84061cd45b246232ad958158f5").
        to_return(json_response("compare.json"))
      comparison = @client.compare("gvaughn/octokit", '0e0d7ae299514da692eb1cab741562c253d44188', 'b7b37f75a80b8e84061cd45b246232ad958158f5')
      expect(comparison.base_commit.sha).to eq('0e0d7ae299514da692eb1cab741562c253d44188')
      expect(comparison.merge_base_commit.sha).to eq('b7b37f75a80b8e84061cd45b246232ad958158f5')
    end
  end

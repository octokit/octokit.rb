require File.expand_path('../../../spec_helper.rb', __FILE__)

describe Octokit::Client::Gists do

  before do
    Octokit.reset!
  end

  after do
    Octokit.reset!
  end

  describe "unauthenticated" do

    before do
      VCR.insert_cassette 'gists'
    end

    after do
      VCR.eject_cassette
    end

    describe ".public_gists" do
      it "returns public gists" do
        gists = Octokit.client.public_gists
        gists.wont_be_empty
        assert_requested :get, github_url('/gists/public')
      end
    end # .public_gists

    describe ".gists" do
      describe "with username passed" do
        it "returns a list of gists" do
          gists = Octokit.client.gists('defunkt')
          gists.wont_be_empty
          assert_requested :get, github_url("/users/defunkt/gists")
        end
      end

      describe "without a username passed" do
        it "returns a list of gists" do
          gists = Octokit.client.gists
          gists.wont_be_empty
          assert_requested :get, github_url("/gists")
        end
      end

    end # .gists

    describe ".gist" do
      it "returns the gist by ID" do
        gist = Octokit.client.gist(790381)
        gist.user.login.must_equal 'jmccartie'
        assert_requested :get, github_url("/gists/790381")
      end
    end

  end # unauthenticated

  describe "when authenticated" do

    before do
      @client = Octokit.client
      @client.login = test_github_login
      @client.password = test_github_password
      VCR.insert_cassette 'authenticated_gists'
    end

    after do
      VCR.eject_cassette
    end

    describe ".gists" do
      it "returns a list of gists" do
        gists = @client.gists
        gists.wont_be_empty
        assert_requested :get, github_url("/gists")
      end
    end # .gists


    describe ".starred_gists" do
      it "returns the user's starred gists" do
        gists = @client.starred_gists
        gists.must_be_kind_of Array
        assert_requested :get, basic_github_url("/gists/starred")
      end
    end # .starred_gists

    describe ".create_gist" do
      it "creates a new gist" do
        new_gist = {
          :description => "A gist from Octokit",
          :public      => true,
          :files       => {
            "zen.text" => { :content => "Keep it logically awesome." }
          }
        }

        gist = @client.create_gist(new_gist)
        gist.user.login.must_equal 'api-padawan'
        gist.files.fields.first.to_s.must_match /zen/
        assert_requested :post, basic_github_url("/gists")
      end
    end # .create_gist

    describe ".edit_gist" do
      it "edit an existing gist" do
        gist = @client.edit_gist(5421307, :description => "GitHub Zen")
        assert_requested :patch, basic_github_url("/gists/5421307")
      end
    end # .edit_gist

    describe ".star_gist" do
      it "stars an existing gist" do
        @client.star_gist(5421463)
        assert_requested :put, basic_github_url("/gists/5421463/star")
        @client.last_response.status.must_equal 204
      end
    end # .star

    describe ".unstar_gist" do
      it "unstars an existing gist" do
        @client.unstar_gist(5421463)
        assert_requested :delete, basic_github_url("/gists/5421463/star")
        @client.last_response.status.must_equal 204
      end
    end # .unstar_gist

    describe ".gist_starred?" do
      it "is starred" do
        starred = @client.gist_starred?(5421307)
        assert_requested :get, basic_github_url("/gists/5421307/star")
        assert starred
      end

      it "is not starred" do
        starred = @client.gist_starred?(5421308)
        assert_requested :get, basic_github_url("/gists/5421308/star")
        refute starred
      end
    end # .gist_starred?

    describe ".fork_gist" do
      it "forks an existing gist" do
        latest = Octokit.client.gists.first
        gist = @client.fork_gist(latest.id)
        gist.description.must_equal latest.description
        assert_requested :post, basic_github_url("/gists/#{latest.id}/forks")
      end
    end # .fork_gist

    describe ".delete_gist" do
      it "deletes an existing gist" do
        new_gist = {
          :description => "A gist from Octokit",
          :public      => true,
          :files       => {
            "zen.text" => { :content => "Keep it logically awesome." }
          }
        }
        gist = @client.create_gist(new_gist)
        @client.delete_gist(gist.id)
        assert_requested :delete, basic_github_url("/gists/#{gist.id}")
      end
    end # .delete_gist

    describe ".gist_comments" do
      it "returns the list of gist comments" do
        comments = @client.gist_comments(5421307)
        comments.must_be_kind_of Array
        assert_requested :get, basic_github_url("/gists/5421307/comments")
      end
    end # .gist_comments

    describe ".gist_comment" do
      it "returns a gist comment" do
        comment = @client.gist_comment("5421307", 818334)
        comment.body.must_match "sparkles"
        assert_requested :get, basic_github_url("/gists/5421307/comments/818334")
      end
    end # .gist_comment

    describe ".create_gist_comment" do
      it "creates a gist comment" do
        comment = @client.create_gist_comment(5421307, ":metal:")
        assert_requested :post, basic_github_url("/gists/5421307/comments")
      end
    end # .create_gist_comment

    describe ".update_gist_comment" do
      it "updates a gist comment" do
        comment = @client.create_gist_comment(5421307, ":metal:")
        update = @client.update_gist_comment(5421307, comment.id, ":heart:")
        assert_requested :patch, basic_github_url("/gists/5421307/comments/#{comment.id}")
      end
    end # .update_gist_comment

    describe ".delete_gist_comment" do
      it "deletes a gist comment" do
        comment = @client.create_gist_comment(5421307, ":metal:")
        @client.delete_gist_comment(5421307, comment.id)
        assert_requested :delete, basic_github_url("/gists/5421307/comments/#{comment.id}")
      end
    end # .delete_gist_comment

  end # authenticated

end

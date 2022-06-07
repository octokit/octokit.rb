# frozen_string_literal: true

require 'helper'

describe Octokit::Client::Gists do
  before do
    Octokit.reset!
  end

  describe 'unauthenticated', :vcr do
    describe '.public_gists' do
      it 'returns public gists' do
        gists = Octokit.client.public_gists
        expect(gists).not_to be_empty
        assert_requested :get, github_url('/gists/public')
      end
    end # .public_gists

    describe '.gists' do
      describe 'with username passed' do
        it 'returns a list of gists' do
          gists = Octokit.client.gists('defunkt')
          expect(gists).not_to be_empty
          assert_requested :get, github_url('/users/defunkt/gists')
        end
      end

      describe 'without a username passed' do
        it 'returns a list of gists' do
          gists = Octokit.client.gists
          expect(gists).not_to be_empty
          assert_requested :get, github_url('/gists')
        end
      end
    end # .gists

    describe '.gist' do
      it 'returns the gist by ID' do
        gist = Octokit.client.gist(790_381)
        expect(gist.owner.login).to eq('jmccartie')
        assert_requested :get, github_url('/gists/790381')
      end

      it 'returns a gist at a specific revision' do
        gist = Octokit.client.gist(790_381, sha: '12e53275c298ab759fa38a1f4980a4aa0556593f')
        expect(gist).to be_kind_of Sawyer::Resource
        assert_requested :get, github_url('/gists/790381/12e53275c298ab759fa38a1f4980a4aa0556593f')
      end
    end
  end # unauthenticated

  describe 'when authenticated', :vcr do
    before do
      @client = oauth_client
      new_gist = {
        description: 'A gist from Octokit',
        public: true,
        files: {
          'zen.text' => { content: 'Keep it logically awesome.' }
        }
      }

      @gist = @client.create_gist(new_gist)
      @gist_comment = @client.create_gist_comment(5_421_307, ':metal:')
    end

    after do
      @client.delete_gist @gist.id
    end

    describe '.gists' do
      it 'returns a list of gists' do
        gists = @client.gists
        expect(gists).not_to be_empty
        assert_requested :get, github_url('/gists')
      end
    end # .gists

    describe '.starred_gists' do
      it "returns the user's starred gists" do
        gists = @client.starred_gists
        expect(gists).to be_kind_of Array
        assert_requested :get, github_url('/gists/starred')
      end
    end # .starred_gists

    describe '.create_gist' do
      it 'creates a new gist' do
        expect(@gist.owner.login).to eq(test_github_login)
        expect(@gist.files.fields.first.to_s).to match(/zen/)
        assert_requested :post, github_url('/gists')
      end
    end # .create_gist

    describe '.edit_gist' do
      it 'edit an existing gist' do
        @client.edit_gist(@gist.id, description: 'GitHub Zen')
        assert_requested :patch, github_url("/gists/#{@gist.id}")
      end
    end # .edit_gist

    describe '.gist_commits' do
      it 'lists a gists commits' do
        @client.gist_commits(@gist.id)
        assert_requested :get, github_url("/gists/#{@gist.id}/commits")
      end
    end # .gist_commits

    describe '.star_gist' do
      it 'stars an existing gist' do
        @client.star_gist(@gist.id)
        assert_requested :put, github_url("/gists/#{@gist.id}/star")
        expect(@client.last_response.status).to eq(204)
      end
    end # .star

    describe '.unstar_gist' do
      it 'unstars an existing gist' do
        @client.unstar_gist(@gist.id)
        assert_requested :delete, github_url("/gists/#{@gist.id}/star")
        expect(@client.last_response.status).to eq(204)
      end
    end # .unstar_gist

    describe '.gist_starred?' do
      it 'is not starred' do
        starred = @client.gist_starred?(5_421_308)
        assert_requested :get, github_url('/gists/5421308/star')
        expect(starred).to be false
      end

      context 'with starred gist' do
        before do
          @client.star_gist(5_421_307)
        end

        it 'is starred' do
          starred = @client.gist_starred?(5_421_307)
          assert_requested :get, github_url('/gists/5421307/star')
          expect(starred).to be true
        end
      end
    end # .gist_starred?

    describe '.fork_gist' do
      it 'forks an existing gist' do
        latest = Octokit.gist(5_506_606)
        gist = @client.fork_gist(latest.id)
        expect(gist.description).to eq(latest.description)
        assert_requested :post, github_url("/gists/#{latest.id}/forks")

        # cleanup so we can re-run later
        @client.delete_gist(gist.id)
      end
    end # .fork_gist

    describe '.gist_forks' do
      it 'lists a gists forks' do
        forks = @client.gist_forks(@gist.id)
        expect(forks).to be_kind_of Array
        assert_requested :get, github_url("/gists/#{@gist.id}/forks")
      end
    end # .gist_forks

    describe '.gist_comments' do
      it 'returns the list of gist comments' do
        comments = @client.gist_comments(5_421_307)
        expect(comments).to be_kind_of Array
        assert_requested :get, github_url('/gists/5421307/comments')
      end
    end # .gist_comments

    describe '.gist_comment' do
      it 'returns a gist comment' do
        comment = @client.gist_comment('5421307', 818_334)
        expect(comment.body).to eq(':sparkles:')
        assert_requested :get, github_url('/gists/5421307/comments/818334')
      end
    end # .gist_comment

    describe '.create_gist_comment' do
      it 'creates a gist comment' do
        assert_requested :post, github_url('/gists/5421307/comments')
      end
    end # .create_gist_comment

    describe '.update_gist_comment' do
      it 'updates a gist comment' do
        @client.update_gist_comment(5_421_307, @gist_comment.id, ':heart:')
        assert_requested :patch, github_url("/gists/5421307/comments/#{@gist_comment.id}")
      end
    end # .update_gist_comment

    describe '.delete_gist_comment' do
      it 'deletes a gist comment' do
        @client.create_gist_comment(5_421_307, ':metal:')
        @client.delete_gist_comment(5_421_307, @gist_comment.id)
        assert_requested :delete, github_url("/gists/5421307/comments/#{@gist_comment.id}")
      end
    end # .delete_gist_comment

    describe '.delete_gist' do
      it 'deletes an existing gist' do
        @client.delete_gist(@gist.id)
        assert_requested :delete, github_url("/gists/#{@gist.id}")
      end
    end # .delete_gist
  end # authenticated
end

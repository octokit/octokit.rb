require 'helper'

describe Octokit::Client::Search do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe ".search_code" do
    it "searches code", :vcr do
      results = @client.search_code 'code user:github in:file extension:gemspec -repo:octokit/octokit.rb', \
        :sort  => 'indexed',
        :order => 'asc'

      assert_requested :get, github_url('/search/code?q=code%20user:github%20in:file%20extension:gemspec%20-repo:octokit/octokit.rb&sort=indexed&order=asc')
      expect(results.total_count).to be_kind_of Fixnum
      expect(results.items).to be_kind_of Array
    end
  end # .search_code

  describe ".search_issues" do
    it "searches issues", :vcr do
      results = @client.search_issues 'http author:jasonrudolph', \
        :sort  => 'created',
        :order => 'desc'

      assert_requested :get, github_url('/search/issues?q=http%20author:jasonrudolph&sort=created&order=desc')
      expect(results.total_count).to be_kind_of Fixnum
      expect(results.items).to be_kind_of Array
    end
  end # .search_issues

  describe ".search_repositories" do
    it "searches repositories", :vcr do
      results = @client.search_repositories 'tetris language:assembly', \
        :sort  => 'stars',
        :order => 'desc'

      assert_requested :get, github_url('/search/repositories?q=tetris%20language:assembly&sort=stars&order=desc')
      expect(results.total_count).to be_kind_of Fixnum
      expect(results.items).to be_kind_of Array
    end
  end # .search_repositories

  describe ".search_users" do
    it "searches users", :vcr do
      results = @client.search_users 'mike followers:>10', \
        :sort  => 'joined',
        :order => 'desc'

      assert_requested :get, github_url('/search/users?q=mike%20followers:%3E10&sort=joined&order=desc')
      expect(results.total_count).to be_kind_of Fixnum
      expect(results.items).to be_kind_of Array
    end

    it "utilizes auto_pagination", :vcr, :record => :new_episodes do
      @client.auto_paginate = true
      results = @client.search_users 'user:pengwynn user:defunkt', :per_page => 1

      expect(results.total_count).to eq(2)
      expect(results.items.length).to eq(2)
    end
  end # .search_users

end


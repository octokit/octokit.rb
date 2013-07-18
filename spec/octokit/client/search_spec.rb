require 'helper'

describe Octokit::Client::Search do

  before do
    Octokit.reset!
    @client = oauth_client
  end

  it "searches code", :vcr do
    results = @client.search_code 'code in:file extension:gemspec -repo:octokit/octokit.rb', \
      :sort  => 'indexed',
      :order => 'asc'

    assert_requested :get, github_url('/search/code?q=code%20in:file%20extension:gemspec%20-repo:octokit/octokit.rb&sort=indexed&order=asc')
    expect(results.total_count).to be_kind_of Fixnum
    expect(results.items).to be_kind_of Array
  end

  it "searches issues", :vcr do
    results = @client.search_issues 'http author:jasonrudolph', \
      :sort  => 'created',
      :order => 'desc'

    assert_requested :get, github_url('/search/issues?q=http%20author:jasonrudolph&sort=created&order=desc')
    expect(results.total_count).to be_kind_of Fixnum
    expect(results.items).to be_kind_of Array
  end

  it "searches repositories", :vcr do
    results = @client.search_repositories 'tetris language:assembly', \
      :sort  => 'stars',
      :order => 'desc'

    assert_requested :get, github_url('/search/repositories?q=tetris%20language:assembly&sort=stars&order=desc')
    expect(results.total_count).to be_kind_of Fixnum
    expect(results.items).to be_kind_of Array
  end

  it "searches users", :vcr do
    results = @client.search_users 'mike followers:>10', \
      :sort  => 'joined',
      :order => 'desc'

    assert_requested :get, github_url('/search/users?q=mike%20followers:%3E10&sort=joined&order=desc')
    expect(results.total_count).to be_kind_of Fixnum
    expect(results.items).to be_kind_of Array
  end

end


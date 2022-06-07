# frozen_string_literal: true

require 'helper'

describe Octokit::Client::Pages do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe '.pages', :vcr do
    it 'lists page information' do
      pages = @client.pages('github/developer.github.com')
      expect(pages.cname).to eq('developer.github.com')
      assert_requested :get, github_url('/repos/github/developer.github.com/pages')
    end
  end # .pages

  describe '.pages_build', :vcr do
    # Grabbed this build ID manually from pages_builds
    it 'lists a specific page build' do
      build = @client.pages_build(@test_repo, 40_071_035, accept: preview_header)
      expect(build.status).not_to be_nil
      assert_requested :get, github_url("/repos/#{@test_repo}/pages/builds/40071035")
    end
  end # .pages_build

  describe '.list_pages_builds', :vcr do
    it 'lists information about all the page builds' do
      builds = @client.pages_builds('github/developer.github.com')
      expect(builds).to be_kind_of Array
      latest_build = builds.first
      expect(latest_build.status).to eq('built')
      assert_requested :get, github_url('/repos/github/developer.github.com/pages/builds')
    end
  end # .list_pages_builds

  describe '.latest_pages_build', :vcr do
    it 'lists information about the latest page build' do
      latest_build = @client.latest_pages_build('github/developer.github.com')
      expect(latest_build.status).to eq('built')
      assert_requested :get, github_url('/repos/github/developer.github.com/pages/builds/latest')
    end
  end # .latest_pages_build

  describe '.request_page_build', :vcr do
    # This test requires some manual setup in your test repository,
    # ensure it has pages site enabled and setup.
    it 'requests a build for the latest revision' do
      request = @client.request_page_build(@test_repo, accept: preview_header)
      expect(request.status).not_to be_nil
      assert_requested :post, github_url("/repos/#{@test_repo}/pages/builds")
    end
  end # .request_page_build

  private

  def preview_header
    Octokit::Preview::PREVIEW_TYPES[:pages]
  end
end

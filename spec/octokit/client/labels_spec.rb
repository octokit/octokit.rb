# frozen_string_literal: true

require 'helper'

describe Octokit::Client::Labels do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  describe '.labels', :vcr do
    it 'returns labels' do
      labels = @client.labels('octokit/octokit.rb')
      expect(labels).to be_kind_of Array
      assert_requested :get, github_url('/repos/octokit/octokit.rb/labels')
    end
  end # .labels

  describe '.label', :vcr do
    it 'returns a single label' do
      label = @client.label('octokit/octokit.rb', 'V3 Addition')
      expect(label.name).to eq('v3 addition')
      assert_requested :get, github_url('/repos/octokit/octokit.rb/labels/V3%20Addition')
    end
    it 'returns a single label with URL characters' do
      @client.delete_label!(@test_repo, 'url-chars?')
      @client.add_label(@test_repo, 'url-chars?')
      label = @client.label(@test_repo, 'url-chars?')
      expect(label.name).to eq('url-chars?')
      assert_requested :get, github_url("/repos/#{@test_repo}/labels/url-chars%3F")
    end
  end # .label

  describe '.add_label', :vcr do
    it 'adds a label with a color' do
      @client.delete_label!(@test_repo, 'test-label')
      label = @client.add_label(@test_repo, 'test-label', 'ededed')
      expect(label.color).to eq('ededed')
      assert_requested :post, github_url("/repos/#{@test_repo}/labels")
    end
    it 'adds a label with default color' do
      @client.delete_label!(@test_repo, 'test-label')
      @client.add_label(@test_repo, 'test-label')
      assert_requested :post, github_url("/repos/#{@test_repo}/labels")
    end
  end # .add_label

  describe '.update_label', :vcr do
    it 'updates a label with a new color' do
      @client.delete_label!(@test_repo, 'test-label')
      label = @client.add_label(@test_repo, 'test-label', 'ededed')

      @client.update_label(@test_repo, label.name, { color: 'ffdd33' })
      assert_requested :patch, github_url("/repos/#{@test_repo}/labels/test-label")
    end
    it 'updates a label with URL characters with a new color' do
      @client.delete_label!(@test_repo, 'url-chars?')
      label = @client.add_label(@test_repo, 'url-chars?', 'ededed')

      @client.update_label(@test_repo, label.name, { color: 'ffdd33' })
      assert_requested :patch, github_url("/repos/#{@test_repo}/labels/url-chars%3F")
    end
  end # .update_label

  context 'with issue' do
    before do
      @issue = @client.create_issue(@test_repo, 'Issue for label test', 'The body')
    end

    describe '.add_labels_to_an_issue', :vcr do
      it 'adds labels to a given issue' do
        @client.add_labels_to_an_issue(@test_repo, @issue.number, ['bug'])
        assert_requested :post, github_url("/repos/#{@test_repo}/issues/#{@issue.number}/labels")
      end
    end # .add_labels_to_an_issue

    describe '.labels_for_issue', :vcr do
      it 'returns all labels for a given issue' do
        labels = @client.labels_for_issue(@test_repo, @issue.number)
        expect(labels).to be_kind_of Array
        assert_requested :get, github_url("/repos/#{@test_repo}/issues/#{@issue.number}/labels")
      end
    end # .labels_for_issue

    describe '.remove_label', :vcr do
      it 'removes a label from the specified issue' do
        @client.add_labels_to_an_issue(@test_repo, @issue.number, ['bug'])

        @client.remove_label(@test_repo, @issue.number, 'bug')
        assert_requested :delete, github_url("/repos/#{@test_repo}/issues/#{@issue.number}/labels/bug")
      end
      it 'removes a label with URL characters from the specified issue' do
        @client.delete_label!(@test_repo, 'url-chars?')
        label = @client.add_label(@test_repo, 'url-chars?')
        @client.add_labels_to_an_issue(@test_repo, @issue.number, ['url-chars?'])

        @client.remove_label(@test_repo, @issue.number, label.name)
        assert_requested :delete, github_url("/repos/#{@test_repo}/issues/#{@issue.number}/labels/url-chars%3F")
      end
    end # .remove_label

    describe '.remove_all_labels', :vcr do
      it 'removes all labels from the specified issue' do
        @client.remove_all_labels(@test_repo, @issue.number)
        assert_requested :delete, github_url("/repos/#{@test_repo}/issues/#{@issue.number}/labels")
      end
    end # .remove_all_labels

    describe '.replace_all_labels', :vcr do
      it 'replaces all labels for an issue' do
        @client.replace_all_labels(@test_repo, @issue.number, %w[bug pdi])
        assert_requested :put, github_url("/repos/#{@test_repo}/issues/#{@issue.number}/labels")
      end
    end # .replace_all_labels
  end # with issue

  describe '.labels_for_milestone', :vcr do
    it 'returns all labels for a repository' do
      labels = @client.labels_for_milestone('octokit/octokit.rb', 2)
      expect(labels).to be_kind_of Array
      assert_requested :get, github_url('/repos/octokit/octokit.rb/milestones/2/labels')
    end
  end # .labels_for_milestone

  describe '.delete_label!', :vcr do
    context 'with label with spaces' do
      before do
        @label = @client.label(@test_repo, 'good first issue')
      end

      after do
        @client.add_label(@test_repo, @label.name, @label.color)
      end

      it 'deletes a label from the repository' do
        @client.delete_label!(@test_repo, @label.name)
        assert_requested :delete, github_url("/repos/#{@test_repo}/labels/good%20first%20issue")
      end
    end

    it 'deletes a label with URL characters from the repository' do
      @client.delete_label!(@test_repo, 'url-chars?')
      assert_requested :delete, github_url("/repos/#{@test_repo}/labels/url-chars%3F")
    end
  end # .delete_label!
end

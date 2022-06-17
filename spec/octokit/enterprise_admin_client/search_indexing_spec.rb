# frozen_string_literal: true

require 'helper'

describe Octokit::EnterpriseAdminClient::SearchIndexing do
  before do
    Octokit.reset!
    @admin_client = enterprise_admin_client
  end

  shared_examples 'search index queuer' do |expected_target|
    context 'with a valid target' do
      it "queues #{expected_target} to be indexed" do
        @admin_client.method(subject).call target
        assert_requested :post,
                         github_enterprise_url('staff/indexing_jobs'),
                         body: { target: expected_target }.to_json
      end
    end

    context 'with invalid target' do
      it 'raises Octokit::NotFound' do
        result = @admin_client.method(subject).call('not-a/real-target')
        expect(result.message).to be_kind_of String
        expect(result.message).to include 'Unknown user'
      end
    end
  end

  shared_examples 'single target queue' do
    it 'identifies the target being indexed in the return message' do
      queue_result = @admin_client.method(subject).call target
      expect(queue_result.message).to be_kind_of String
      expect(queue_result.message).to include target
    end
  end

  shared_examples 'multiple target queue' do
    it 'identifies targets that were queued for index in the return message' do
      queue_result = @admin_client.method(subject).call target
      expect(queue_result.message).to be_kind_of Array
      expect(queue_result.message.first).to include target
    end
  end

  describe '.index_user', :vcr do
    subject { :index_user }
    let(:target) { 'api-padawan' }
    it_behaves_like 'search index queuer', 'api-padawan'
    it_behaves_like 'single target queue'
  end

  describe '.index_repository', :vcr do
    subject { :index_repository }
    let(:target) { 'api-playground/api-sandbox' }
    it_behaves_like 'search index queuer', 'api-playground/api-sandbox'
    it_behaves_like 'single target queue'
  end

  describe '.index_repository_issues', :vcr do
    subject { :index_repository_issues }
    let(:target) { 'api-playground/api-sandbox' }
    it_behaves_like 'search index queuer', 'api-playground/api-sandbox/issues'
    it_behaves_like 'single target queue'
  end

  describe '.index_repository_code', :vcr do
    subject { :index_repository_code }
    let(:target) { 'api-playground/api-sandbox' }
    it_behaves_like 'search index queuer', 'api-playground/api-sandbox/code'
    it_behaves_like 'single target queue'
  end

  describe '.index_users_repositories', :vcr do
    subject { :index_users_repositories }
    let(:target) { 'api-padawan' }
    it_behaves_like 'search index queuer', 'api-padawan/*'
    it_behaves_like 'multiple target queue'
  end

  describe '.index_users_repositories_issues', :vcr do
    subject { :index_users_repositories_issues }
    let(:target) { 'api-padawan' }
    it_behaves_like 'search index queuer', 'api-padawan/*/issues'
    it_behaves_like 'multiple target queue'
  end

  describe '.index_users_repositories_code', :vcr do
    subject { :index_users_repositories_code }
    let(:target) { 'api-padawan' }
    it_behaves_like 'search index queuer', 'api-padawan/*/code'
    it_behaves_like 'multiple target queue'
  end
end

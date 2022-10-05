# frozen_string_literal: true

require 'helper'

describe Octokit::Client::RepositoryInvitations do
  before do
    Octokit.reset!
    @client = oauth_client
  end

  context 'with repository' do
    before(:each) do
      @repo = @client.create_repository('an-repo', organization: test_github_org)
    end

    after(:each) do
      begin
        @client.delete_repository(@repo.id)
      rescue Octokit::NotFound
      end
    end

    describe '.invite_user_to_repository', :vcr do
      it 'invites a user to a repository' do
        @client.invite_user_to_repository(@repo.id, 'tarebyte')
        assert_requested :put, github_url("/repositories/#{@repo.id}/collaborators/tarebyte")
      end
    end

    describe '.repository_invitations', :vcr do
      it 'lists the repositories outstanding invitations' do
        invitations = @client.repository_invitations(@repo.id)
        expect(invitations).to be_kind_of(Array)
        assert_requested :get, github_url("/repositories/#{@repo.id}/invitations")
      end
    end

    describe '.user_repository_invitations', :vcr do
      it 'lists the users repository invitations' do
        invitations = @client.user_repository_invitations
        expect(invitations).to be_kind_of(Array)
        assert_requested :get, github_url('/user/repository_invitations')
      end
    end

    context 'with stubbed repository invitation' do
      before do
        @invitation_id = 8_675_309
      end

      describe '.accept_repository_invitation', :vcr do
        it 'accepts the repository invitation on behalf of the user' do
          request = stub_patch("/user/repository_invitations/#{@invitation_id}")
          @client.accept_repository_invitation(@invitation_id)
          assert_requested request
        end
      end

      describe '.decline_repository_invitation', :vcr do
        it 'declines the repository invitation on behalf of the user' do
          request = stub_delete("/user/repository_invitations/#{@invitation_id}")
          @client.decline_repository_invitation(@invitation_id)
          assert_requested request
        end
      end
    end

    context 'with repository invitation' do
      before(:each) do
        @invitation = @client.invite_user_to_repository(@repo.id, 'tarebyte')
      end

      describe '.delete_repository_invitation', :vcr do
        it 'deletes the repository invitation' do
          @client.delete_repository_invitation(@repo.id, @invitation.id)
          assert_requested :delete, github_url("/repositories/#{@repo.id}/invitations/#{@invitation.id}")
        end
      end

      describe '.update_repository_invitation', :vcr do
        it 'updates the repository invitation' do
          @client.update_repository_invitation(@repo.id, @invitation.id, permissions: 'read')
          assert_requested :patch, github_url("/repositories/#{@repo.id}/invitations/#{@invitation.id}")
        end
      end
    end
  end
end

# frozen_string_literal: true

require 'helper'

describe Octokit::EnterpriseAdminClient::Users do
  before do
    Octokit.reset!
    @admin_client = enterprise_admin_client
  end

  describe '.create_user', :vcr do
    it 'creates a new user' do
      @admin_client.create_user('foobar', 'notreal@foo.bar')
      expect(@admin_client.last_response.status).to eq(201)
      assert_requested :post, github_enterprise_url('admin/users')
    end
  end # .create_user

  describe '.promote', :vcr do
    it 'promotes an ordinary user to a site administrator' do
      @admin_client.promote('pengwynn')
      assert_requested :put, github_enterprise_url('users/pengwynn/site_admin')
    end
  end # .promote

  describe '.demote', :vcr do
    it 'demotes a site administrator to an ordinary user' do
      @admin_client.demote('pengwynn')
      assert_requested :delete, github_enterprise_url('users/pengwynn/site_admin')
    end
  end # .demote

  describe '.rename_user', :vcr do
    it 'rename a user' do
      @admin_client.rename_user('foobar', 'foofoobar')
      expect(@admin_client.last_response.status).to eq(202)
      assert_requested :patch, github_enterprise_url('admin/users/foobar')
    end
  end # .rename_user

  describe '.suspend', :vcr do
    it 'suspends a user' do
      @admin_client.suspend('pengwynn')
      assert_requested :put, github_enterprise_url('users/pengwynn/suspended')
    end
  end # .suspend

  describe '.unsuspend', :vcr do
    it 'unsuspends a user' do
      @admin_client.unsuspend('pengwynn')
      assert_requested :delete, github_enterprise_url('users/pengwynn/suspended')
    end
  end # .unsuspend

  describe '.delete_user', :vcr do
    it 'deletes a user' do
      @admin_client.delete_user('afakeperson')
      expect(@admin_client.last_response.status).to eq(204)
      assert_requested :delete, github_enterprise_url('admin/users/afakeperson')
    end
  end # .delete_user

  describe '.create_impersonation_token', :vcr do
    it 'creates an impersonation token as a user' do
      @admin_client.create_impersonation_token('mikemcquaid')
      expect(@admin_client.last_response.status).to eq(201)
      assert_requested :post, github_enterprise_url('admin/users/mikemcquaid/authorizations')
    end
  end # .create_impersonation_token

  describe '.delete_impersonation_token', :vcr do
    it 'deletes an impersonation token as a user' do
      @admin_client.delete_impersonation_token('foobar')
      expect(@admin_client.last_response.status).to eq(204)
      assert_requested :delete, github_enterprise_url('admin/users/foobar/authorizations')
    end
  end # .delete_impersonation_token

  describe '.list_all_keys', :vcr do
    it 'lists all public keys' do
      result = @admin_client.list_all_keys
      expect(@admin_client.last_response.status).to eq(200)
      expect(result).to be_kind_of Array
      assert_requested :get, github_enterprise_url('admin/keys')
    end
  end # .list_all_keys

  describe '.delete_key', :vcr do
    it 'deletes a public keys' do
      @admin_client.delete_key(1)
      expect(@admin_client.last_response.status).to eq(204)
      assert_requested :delete, github_enterprise_url('admin/keys/1')
    end
  end # .delete_key
end

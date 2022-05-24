require 'helper'

describe Octokit::Client::Apps do
  before(:each) do
    Octokit.reset!
    @client     = oauth_client
    @jwt_client = Octokit::Client.new(:bearer_token => new_jwt_token)
    use_vcr_placeholder_for(@jwt_client.bearer_token, '<JWT_BEARER_TOKEN>')
  end

  after(:each) do
    Octokit.reset!
  end

  describe ".app", :vcr do
    it "returns current App" do
      response = @jwt_client.app()

      expect(response.id).not_to be_nil
      assert_requested :get, github_url("/app")
    end

    it "works for GitHub Enterprise installs" do
      client = Octokit::Client.new \
        bearer_token: new_jwt_token,
        api_endpoint: "https://ghe.local/api/v3"

      request = stub_get("https://ghe.local/api/v3/app")
      response = client.app()

      assert_requested request
    end
  end

  describe ".find_integration_installations", :vcr do
    it "returns installations for an integration" do
      allow(@jwt_client).to receive(:octokit_warn)
      installations = @jwt_client.find_integration_installations
      expect(installations).to be_kind_of Array
      assert_requested :get, github_url("/app/installations")
      expect(@jwt_client).to have_received(:octokit_warn).with(/Deprecated/)
    end
  end # .find_integration_installations

  describe ".find_app_installations", :vcr do
    it "returns installations for an app" do
      installations = @jwt_client.find_app_installations()
      expect(installations).to be_kind_of Array
      assert_requested :get, github_url("/app/installations")
    end

    it "works for GitHub Enterprise installs" do
      client = Octokit::Client.new \
        bearer_token: new_jwt_token,
        api_endpoint: "https://ghe.local/api/v3"

      request = stub_get("https://ghe.local/api/v3/app/installations")
      response = client.find_app_installations()

      assert_requested request
    end
  end # .find_app_installations

  describe ".find_user_installations", :vcr do
    it "returns installations for a user" do
      response = @client.find_user_installations()

      expect(response.total_count).not_to be_nil
      expect(response.installations).to be_kind_of(Array)
      assert_requested :get, github_url("/user/installations")
    end

    it "works for GitHub Enterprise installs" do
      client = Octokit::Client.new \
        bearer_token: new_jwt_token,
        api_endpoint: "https://ghe.local/api/v3"

      request = stub_get("https://ghe.local/api/v3/user/installations")
      response = client.find_user_installations()

      assert_requested request
    end

    it "allows auto_pagination", :vcr do
      @client.auto_paginate = true
      response = @client.find_user_installations(per_page: 1)

      expect(response.total_count).to eq 2
      expect(response.installations.count).to eq 2
      expect(response.installations).to be_kind_of(Array)
    end
  end # .find_user_installations

  describe ".find_organization_installation", :vcr do
    let(:organization) { test_github_org }

    it "returns installation for an organization" do
      response = @jwt_client.find_organization_installation(organization)

      expect(response.id).not_to be_nil
      expect(response.target_type).to eq("Organization")
      assert_requested :get, github_url("/orgs/#{organization}/installation")
    end

    it "works for GitHub Enterprise installs" do
      client = Octokit::Client.new \
        bearer_token: new_jwt_token,
        api_endpoint: "https://ghe.local/api/v3"

      request = stub_get("https://ghe.local/api/v3/organizations/1234/installation")
      response = client.find_organization_installation(1234)

      assert_requested request
    end

    it "allows auto_pagination" do
      @jwt_client.auto_paginate = true
      response = @jwt_client.find_organization_installation(organization, per_page: 1)

      expect(response.id).not_to be_nil
      expect(response.target_type).to eq("Organization")
    end
  end # .find_organization_installation

  describe ".find_repository_installation", :vcr do

    it "returns installation for an repository" do
      response = @jwt_client.find_repository_installation(@test_org_repo)

      expect(response.id).not_to be_nil
      expect(response.target_type).to eq("Organization")
      assert_requested :get, github_url("/repos/#{@test_org_repo}/installation")
    end

    it "works for GitHub Enterprise installs" do
      client = Octokit::Client.new \
        bearer_token: new_jwt_token,
        api_endpoint: "https://ghe.local/api/v3"

      request = stub_get("https://ghe.local/api/v3/repos/testing/1234/installation")
      response = client.find_repository_installation('testing/1234')

      assert_requested request
    end

    it "allows auto_pagination" do
      @jwt_client.auto_paginate = true
      response = @jwt_client.find_repository_installation(@test_org_repo, per_page: 1)

      expect(response.id).not_to be_nil
      expect(response.target_type).to eq("Organization")
    end
  end # .find_repository_installation

  describe ".find_user_installation", :vcr do
    let(:user) { test_github_login }

    it "returns installation for a user" do
      response = @jwt_client.find_user_installation(user)

      expect(response.id).not_to be_nil
      expect(response.account.login).to eq(user)
      assert_requested :get, github_url("/users/#{user}/installation")
    end

    it "works for GitHub Enterprise installs" do
      client = Octokit::Client.new \
        bearer_token: new_jwt_token,
        api_endpoint: "https://ghe.local/api/v3"

      request = stub_get("https://ghe.local/api/v3/users/1234/installation")
      response = client.find_user_installation('1234')

      assert_requested request
    end

    it "allows auto_pagination" do
      @jwt_client.auto_paginate = true
      response = @jwt_client.find_user_installation(user, per_page: 1)

      expect(response.id).not_to be_nil
      expect(response.account.login).to eq(user)
    end
  end # .find_user_installation

  context "with app installation", :vcr do
    let(:installation) { test_github_integration_installation }

    describe ".installation" do
      it "returns the installation" do
        response = @jwt_client.installation(installation)
        expect(response).to be_kind_of Sawyer::Resource
        assert_requested :get, github_url("/app/installations/#{installation}")
      end

      it "works for GitHub Enterprise installs" do
        client = Octokit::Client.new \
          bearer_token: new_jwt_token,
          api_endpoint: "https://ghe.local/api/v3"

        request = stub_get("https://ghe.local/api/v3/app/installations/1234")
        response = client.installation(1234)

        assert_requested request
      end
    end # .installation

    describe ".find_installation_repositories_for_user" do
      it "returns repositories for a user" do
        response = @client.find_installation_repositories_for_user(installation)
        expect(response.total_count).not_to be_nil
        expect(response.repositories).to be_kind_of(Array)
        assert_requested :get, github_url("/user/installations/#{installation}/repositories")
      end

      it "works for GitHub Enterprise installs" do
        client = Octokit::Client.new \
          bearer_token: new_jwt_token,
          api_endpoint: "https://ghe.local/api/v3"

        request = stub_get("https://ghe.local/api/v3/user/installations/1234/repositories")
        response = client.find_installation_repositories_for_user(1234)

        assert_requested request
      end

      it "allows auto_pagination", :vcr do
        @client.auto_paginate = true
        response = @client.find_installation_repositories_for_user(installation, per_page: 1)

        expect(response.total_count).to eq 2
        expect(response.repositories.count).to eq 2
        expect(response.repositories).to be_kind_of(Array)
      end
    end # .find_installation_repositories_for_user

    describe ".create_integration_installation_access_token" do
      it "creates an access token for the installation" do
        allow(@jwt_client).to receive(:octokit_warn)
        response = @jwt_client.create_integration_installation_access_token(installation)

        expect(response).to be_kind_of(Sawyer::Resource)
        expect(response.token).not_to be_nil
        expect(response.expires_at).not_to be_nil

        assert_requested :post, github_url("/app/installations/#{installation}/access_tokens")
        expect(@jwt_client).to have_received(:octokit_warn).with(/Deprecated/)
      end
    end # .create_integration_installation_access_token

    describe ".create_app_installation_access_token" do
      it "creates an access token for the installation" do
        response = @jwt_client.create_app_installation_access_token(installation)

        expect(response).to be_kind_of(Sawyer::Resource)
        expect(response.token).not_to be_nil
        expect(response.expires_at).not_to be_nil

        assert_requested :post, github_url("/app/installations/#{installation}/access_tokens")
      end

      it "works for GitHub Enterprise installs" do
        client = Octokit::Client.new \
          bearer_token: new_jwt_token,
          api_endpoint: "https://ghe.local/api/v3"

        path = "app/installations/1234/access_tokens"
        request = stub_post("https://ghe.local/api/v3/#{path}")
        response = client.create_app_installation_access_token(1234)

        assert_requested request
      end
    end # .create_app_installation_access_token

    describe ".delete_installation" do
      it "deletes an installation" do
        response = @jwt_client.delete_installation(installation)
        expect(response).to be_truthy
      end
    end # .delete_installation

    context "with app installation access token" do
      let(:installation_client) do
        token = @jwt_client.create_app_installation_access_token(installation).token
        use_vcr_placeholder_for(token, '<INTEGRATION_INSTALLATION_TOKEN>')
        Octokit::Client.new(:access_token => token)
      end

      let(:ghe_installation_client) do
        Octokit::Client.new \
          access_token: "v1.1f699f1069f60xxx",
          api_endpoint: "https://ghe.local/api/v3"
      end

      describe ".list_integration_installation_repositories" do
        it "lists the installations repositories" do
          allow(installation_client).to receive(:octokit_warn)
          response = installation_client.list_integration_installation_repositories()
          expect(response.total_count).not_to be_nil
          expect(response.repositories).to be_kind_of(Array)
          expect(installation_client).to have_received(:octokit_warn).with(/Deprecated/)
        end
      end # .list_integration_installation_repositories

      describe ".list_app_installation_repositories" do
        it "lists the installations repositories" do
          response = installation_client.list_app_installation_repositories()
          expect(response.total_count).not_to be_nil
          expect(response.repositories).to be_kind_of(Array)
        end

        it "works for GitHub Enterprise installs" do
          request = stub_get("https://ghe.local/api/v3/installation/repositories")
          response = ghe_installation_client.list_app_installation_repositories()
          assert_requested request
        end
        it "allows auto_pagination", :vcr do
          installation_client.auto_paginate = true
          response = installation_client.list_app_installation_repositories({per_page: 1})

          expect(response.total_count).to eq 2
          expect(response.repositories.count).to eq 2
          expect(response.repositories).to be_kind_of(Array)
        end
      end # .list_app_installation_repositories
    end # with app installation access token

    context "with repository" do
      let(:repository) { test_org_repo }

      before(:each) do
        @repo = @client.create_repository(
          "#{test_github_repository}_#{Time.now.to_f}",
          :organization => test_github_org
        )
      end

      after(:each) do
        @client.delete_repository(@repo.full_name)
      end

      describe ".add_repository_to_integration_installation" do
        it "adds the repository to the installation" do
          allow(@client).to receive(:octokit_warn)
          response = @client.add_repository_to_integration_installation(installation, @repo.id)
          expect(response).to be_truthy
          expect(@client).to have_received(:octokit_warn).with(/Deprecated/)
        end
      end # .add_repository_to_integration_installation

      describe ".add_repository_to_app_installation" do
        it "adds the repository to the installation" do
          response = @client.add_repository_to_app_installation(installation, @repo.id)
          expect(response).to be_truthy
        end
      end # .add_repository_to_app_installation

      context 'with installed repository on installation' do
        before(:each) do
          @client.add_repository_to_app_installation(installation, @repo.id)
        end

        describe ".remove_repository_from_integration_installation" do
          it "removes the repository from the installation" do
            allow(@client).to receive(:octokit_warn)
            response = @client.remove_repository_from_integration_installation(installation, @repo.id)
            expect(response).to be_truthy
            expect(@client).to have_received(:octokit_warn).with(/Deprecated/)
          end
        end # .remove_repository_from_integration_installation

        describe ".remove_repository_from_app_installation" do
          it "removes the repository from the installation" do
            response = @client.remove_repository_from_app_installation(installation, @repo.id)
            expect(response).to be_truthy
          end
        end # .remove_repository_from_app_installation
      end # with installed repository on installation
    end # with repository

    context "with repository on GitHub Enterprise" do
      let(:ghe_client) do
        Octokit::Client.new \
          access_token: "x" * 40,
          api_endpoint: "https://ghe.local/api/v3"
      end

      describe ".add_repository_to_app_installation" do
        it "works for GitHub Enterprise installs" do
          request = stub_put("https://ghe.local/api/v3/user/installations/1234/repositories/1234")
          response = ghe_client.add_repository_to_app_installation(1234, 1234)
          assert_requested request
        end
      end # .add_repository_to_app_installation

      describe ".remove_repository_from_app_installation" do
        it "works for GitHub Enterprise installs" do
          request = stub_delete("https://ghe.local/api/v3/user/installations/1234/repositories/1234")
          response = ghe_client.remove_repository_from_app_installation(1234, 1234)
          assert_requested request
        end
      end # .remove_repository_from_app_installation
    end # with repository on GitHub Enterprise
  end # with app installation
end

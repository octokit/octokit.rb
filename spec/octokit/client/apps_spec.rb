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
      installations = @jwt_client.find_integration_installations
      expect(installations).to be_kind_of Array
      assert_requested :get, github_url("/app/installations")
    end
  end # .find_app_installations

  context "with app installation", :vcr do
    let(:installation) { test_github_integration_installation }

    describe ".installation" do
      it "returns the installation" do
        response = @jwt_client.installation(installation)
        expect(response).to be_kind_of Sawyer::Resource
        assert_requested :get, github_url("/app/installations/#{installation}")
      end
    end # .installation

    describe ".create_integration_installation_access_token" do
      it "creates an access token for the installation" do
        allow(@jwt_client).to receive(:octokit_warn)
        response = @jwt_client.create_integration_installation_access_token(installation)

        expect(response).to be_kind_of(Sawyer::Resource)
        expect(response.token).not_to be_nil
        expect(response.expires_at).not_to be_nil

        assert_requested :post, github_url("/installations/#{installation}/access_tokens")
        expect(@jwt_client).to have_received(:octokit_warn).with(/Deprecated/)
      end
    end # .create_integration_installation_access_token

    describe ".create_app_installation_access_token" do
      it "creates an access token for the installation" do
        response = @jwt_client.create_app_installation_access_token(installation)

        expect(response).to be_kind_of(Sawyer::Resource)
        expect(response.token).not_to be_nil
        expect(response.expires_at).not_to be_nil

        assert_requested :post, github_url("/installations/#{installation}/access_tokens")
      end
    end # .create_app_installation_access_token

    context "with app installation access token" do
      let(:installation_client) do
        token = @jwt_client.create_app_installation_access_token(installation).token
        use_vcr_placeholder_for(token, '<INTEGRATION_INSTALLATION_TOKEN>')
        Octokit::Client.new(:access_token => token)
      end

      describe ".list_integration_installation_repositories" do
        it "lists the installations repositories" do
          allow(installation_client).to receive(:octokit_warn)
          response = installation_client.list_integration_installation_repositories
          expect(response.total_count).not_to be_nil
          expect(response.repositories).to be_kind_of(Array)
          expect(installation_client).to have_received(:octokit_warn).with(/Deprecated/)
        end
      end # .list_integration_installation_repositories

      describe ".list_app_installation_repositories" do
        it "lists the installations repositories" do
          response = installation_client.list_app_installation_repositories
          expect(response.total_count).not_to be_nil
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
  end # with app installation

  private

  def new_jwt_token
    private_pem = File.read(test_github_integration_pem_key)
    private_key = OpenSSL::PKey::RSA.new(private_pem)

    payload = {}.tap do |opts|
      opts[:iat] = Time.now.to_i           # Issued at time.
      opts[:exp] = opts[:iat] + 600        # JWT expiration time is 10 minutes from issued time.
      opts[:iss] = test_github_integration # Integration's GitHub identifier.
    end

    JWT.encode(payload, private_key, 'RS256')
  end
end

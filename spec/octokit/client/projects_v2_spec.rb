# frozen_string_literal: true

describe Octokit::Client::ProjectsV2 do
  context 'with an org' do
    let(:organization) { test_github_org }
    let(:project_number) { 1 }

    describe '.org_projects_v2', :vcr do
      it 'returns a list of projects for an organization' do
        projects = oauth_client.org_projects_v2(organization)
        expect(projects).to be_kind_of Array
        assert_requested :get, github_url("/orgs/#{organization}/projectsV2")
      end
    end # .org_projects_v2

    describe '.org_project_v2', :vcr do
      it 'returns a specific project for an organization' do
        project = oauth_client.org_project_v2(organization, project_number)
        expect(project).to be_kind_of Sawyer::Resource
        assert_requested :get, github_url("/orgs/#{organization}/projectsV2/#{project_number}")
      end
    end # .org_project_v2

    describe '.org_project_v2_fields', :vcr do
      it 'returns a list of project fields for an organization' do
        fields = oauth_client.org_project_v2_fields(organization, project_number)
        expect(fields).to be_kind_of Array
        assert_requested :get, github_url("/orgs/#{organization}/projectsV2/#{project_number}/fields")
      end
    end # .org_project_v2_fields

    describe '.org_project_v2_field', :vcr do
      it 'returns a specific project field for an organization' do
        field_id = oauth_client.org_project_v2_fields(organization, project_number).first.id
        field = oauth_client.org_project_v2_field(organization, project_number, field_id)
        expect(field.id).to eq(field_id)
        assert_requested :get, github_url("/orgs/#{organization}/projectsV2/#{project_number}/fields/#{field_id}")
      end
    end # .org_project_v2_field

    describe '.create_org_project_v2_field', :vcr do
      it 'adds a field to a project for an organization' do
        field = oauth_client.create_org_project_v2_field(organization, project_number, name: "Octokit field #{Time.now.to_i}", data_type: 'text')
        expect(field.data_type).to eq('text')
        assert_requested :post, github_url("/orgs/#{organization}/projectsV2/#{project_number}/fields")
      end
    end # .create_org_project_v2_field

    describe '.create_org_project_v2_draft_item', :vcr do
      it 'creates a draft item in a project for an organization' do
        item = oauth_client.create_org_project_v2_draft_item(organization, project_number, 'Octokit draft', body: 'Draft body')
        expect(item.content_type).to eq('DraftIssue')
        assert_requested :post, github_url("/orgs/#{organization}/projectsV2/#{project_number}/drafts")
      end
    end # .create_org_project_v2_draft_item

    describe '.add_org_project_v2_item', :vcr do
      it 'adds an issue to a project for an organization' do
        issue = oauth_client.create_issue(@test_org_repo, 'Octokit project item')
        item = oauth_client.add_org_project_v2_item(organization, project_number, 'Issue', id: issue.id)
        expect(item.content_type).to eq('Issue')
        assert_requested :post, github_url("/orgs/#{organization}/projectsV2/#{project_number}/items")
      end
    end # .add_org_project_v2_item

    context 'with an item' do
      let(:item_id) do
        oauth_client.create_org_project_v2_draft_item(organization, project_number, 'Octokit item').id
      end

      describe '.org_project_v2_items', :vcr do
        it 'returns a list of items in a project for an organization' do
          item_id
          items = oauth_client.org_project_v2_items(organization, project_number)
          expect(items).not_to be_empty
          expect(items.map(&:project_url)).to all(eq(github_url("/orgs/#{organization}/projectsV2/#{project_number}")))
          assert_requested :get, github_url("/orgs/#{organization}/projectsV2/#{project_number}/items")
        end
      end # .org_project_v2_items

      describe '.org_project_v2_item', :vcr do
        it 'returns a specific item in a project for an organization' do
          item = oauth_client.org_project_v2_item(organization, project_number, item_id)
          expect(item.id).to eq(item_id)
          assert_requested :get, github_url("/orgs/#{organization}/projectsV2/#{project_number}/items/#{item_id}")
        end
      end # .org_project_v2_item

      describe '.update_org_project_v2_item', :vcr do
        it 'updates an item in a project for an organization' do
          field = oauth_client.create_org_project_v2_field(organization, project_number, name: "Octokit field #{Time.now.to_i}", data_type: 'text')
          item = oauth_client.update_org_project_v2_item(organization, project_number, item_id, [{ id: field.id, value: 'Updated' }])
          expect(item.id).to eq(item_id)
          assert_requested :patch, github_url("/orgs/#{organization}/projectsV2/#{project_number}/items/#{item_id}")
        end
      end # .update_org_project_v2_item

      describe '.delete_org_project_v2_item', :vcr do
        it 'deletes an item from a project for an organization' do
          result = oauth_client.delete_org_project_v2_item(organization, project_number, item_id)
          expect(result).to be true
          assert_requested :delete, github_url("/orgs/#{organization}/projectsV2/#{project_number}/items/#{item_id}")
        end
      end # .delete_org_project_v2_item
    end # with an item

    describe '.create_org_project_v2_view', :vcr do
      it 'creates a view in a project for an organization' do
        view = oauth_client.create_org_project_v2_view(organization, project_number, 'Octokit board', 'board')
        expect(view.name).to eq('Octokit board')
        assert_requested :post, github_url("/orgs/#{organization}/projectsV2/#{project_number}/views")
      end
    end # .create_org_project_v2_view

    describe '.org_project_v2_view_items', :vcr do
      it 'returns a list of items in a project view for an organization' do
        view = oauth_client.create_org_project_v2_view(organization, project_number, 'Octokit table', 'table')
        items = oauth_client.org_project_v2_view_items(organization, project_number, view.number)
        expect(items).not_to be_empty
        expect(items.map(&:project_url)).to all(eq(github_url("/orgs/#{organization}/projectsV2/#{project_number}")))
        assert_requested :get, github_url("/orgs/#{organization}/projectsV2/#{project_number}/views/#{view.number}/items")
      end
    end # .org_project_v2_view_items
  end # with an org

  context 'with a user' do
    let(:username) { test_github_login }
    let(:project_number) { 1 }
    let(:user_id) { test_github_user_id }

    describe '.user_projects_v2', :vcr do
      it 'returns a list of projects for a user' do
        projects = oauth_client.user_projects_v2(username)
        expect(projects).to be_kind_of Array
        assert_requested :get, github_url("/users/#{username}/projectsV2")
      end
    end # .user_projects_v2

    describe '.user_project_v2', :vcr do
      it 'returns a specific project for a user' do
        project = oauth_client.user_project_v2(username, project_number)
        expect(project).to be_kind_of Sawyer::Resource
        assert_requested :get, github_url("/users/#{username}/projectsV2/#{project_number}")
      end
    end # .user_project_v2

    describe '.user_project_v2_fields', :vcr do
      it 'returns a list of project fields for a user' do
        fields = oauth_client.user_project_v2_fields(username, project_number)
        expect(fields).to be_kind_of Array
        assert_requested :get, github_url("/users/#{username}/projectsV2/#{project_number}/fields")
      end
    end # .user_project_v2_fields

    describe '.user_project_v2_field', :vcr do
      it 'returns a specific project field for a user' do
        field_id = oauth_client.user_project_v2_fields(username, project_number).first.id
        field = oauth_client.user_project_v2_field(username, project_number, field_id)
        expect(field.id).to eq(field_id)
        assert_requested :get, github_url("/users/#{username}/projectsV2/#{project_number}/fields/#{field_id}")
      end
    end # .user_project_v2_field

    describe '.create_user_project_v2_field', :vcr do
      it 'adds a field to a project for a user' do
        field = oauth_client.create_user_project_v2_field(username, project_number, name: "Octokit field #{Time.now.to_i}", data_type: 'text')
        expect(field.data_type).to eq('text')
        assert_requested :post, github_url("/users/#{username}/projectsV2/#{project_number}/fields")
      end
    end # .create_user_project_v2_field

    describe '.create_user_project_v2_draft_item', :vcr do
      it 'creates a draft item in a project for a user' do
        item = oauth_client.create_user_project_v2_draft_item(user_id, project_number, 'Octokit draft', body: 'Draft body')
        expect(item.content_type).to eq('DraftIssue')
        assert_requested :post, github_url("/user/#{user_id}/projectsV2/#{project_number}/drafts")
      end
    end # .create_user_project_v2_draft_item

    describe '.add_user_project_v2_item', :vcr do
      it 'adds an issue to a project for a user' do
        issue = oauth_client.create_issue(@test_repo, 'Octokit project item')
        item = oauth_client.add_user_project_v2_item(username, project_number, 'Issue', id: issue.id)
        expect(item.content_type).to eq('Issue')
        assert_requested :post, github_url("/users/#{username}/projectsV2/#{project_number}/items")
      end
    end # .add_user_project_v2_item

    context 'with an item' do
      let(:item_id) do
        oauth_client.create_user_project_v2_draft_item(user_id, project_number, 'Octokit item').id
      end

      describe '.user_project_v2_items', :vcr do
        it 'returns a list of items in a project for a user' do
          item_id
          items = oauth_client.user_project_v2_items(username, project_number)
          expect(items).not_to be_empty
          expect(items.map(&:project_url)).to all(eq(github_url("/users/#{username}/projectsV2/#{project_number}")))
          assert_requested :get, github_url("/users/#{username}/projectsV2/#{project_number}/items")
        end
      end # .user_project_v2_items

      describe '.user_project_v2_item', :vcr do
        it 'returns a specific item in a project for a user' do
          item = oauth_client.user_project_v2_item(username, project_number, item_id)
          expect(item.id).to eq(item_id)
          assert_requested :get, github_url("/users/#{username}/projectsV2/#{project_number}/items/#{item_id}")
        end
      end # .user_project_v2_item

      describe '.update_user_project_v2_item', :vcr do
        it 'updates an item in a project for a user' do
          field = oauth_client.create_user_project_v2_field(username, project_number, name: "Octokit field #{Time.now.to_i}", data_type: 'text')
          item = oauth_client.update_user_project_v2_item(username, project_number, item_id, [{ id: field.id, value: 'Updated' }])
          expect(item.id).to eq(item_id)
          assert_requested :patch, github_url("/users/#{username}/projectsV2/#{project_number}/items/#{item_id}")
        end
      end # .update_user_project_v2_item

      describe '.delete_user_project_v2_item', :vcr do
        it 'deletes an item from a project for a user' do
          result = oauth_client.delete_user_project_v2_item(username, project_number, item_id)
          expect(result).to be true
          assert_requested :delete, github_url("/users/#{username}/projectsV2/#{project_number}/items/#{item_id}")
        end
      end # .delete_user_project_v2_item
    end # with an item

    describe '.create_user_project_v2_view', :vcr do
      it 'creates a view in a project for a user' do
        view = oauth_client.create_user_project_v2_view(username, project_number, 'Octokit board', 'board')
        expect(view.name).to eq('Octokit board')
        assert_requested :post, github_url("/users/#{username}/projectsV2/#{project_number}/views")
      end
    end # .create_user_project_v2_view

    describe '.user_project_v2_view_items', :vcr do
      it 'returns a list of items in a project view for a user' do
        view = oauth_client.create_user_project_v2_view(username, project_number, 'Octokit table', 'table')
        items = oauth_client.user_project_v2_view_items(username, project_number, view.number)
        expect(items).not_to be_empty
        expect(items.map(&:project_url)).to all(eq(github_url("/users/#{username}/projectsV2/#{project_number}")))
        assert_requested :get, github_url("/users/#{username}/projectsV2/#{project_number}/views/#{view.number}/items")
      end
    end # .user_project_v2_view_items
  end # with a user
end # Octokit::Client::ProjectsV2

# frozen_string_literal: true

describe Octokit::Client::Projects do
  describe '.projects', :vcr do
    it 'returns a list of projects for a repository' do
      projects = oauth_client.projects('octokit/octokit.rb')
      expect(projects).to be_kind_of Array
      assert_requested :get, github_url('/repos/octokit/octokit.rb/projects')
    end
  end # .projects

  describe '.create_project', :vcr do
    it 'returns the newly created project' do
      project = oauth_client.create_project(@test_repo, 'api kpi')
      expect(project.name).to eq('api kpi')
      assert_requested :post, github_url("/repos/#{@test_repo}/projects")
    end
  end # .create_project

  describe '.org_projects', :vcr do
    it 'returns the projects for an organization' do
      projects = oauth_client.org_projects(test_github_org)
      expect(projects).to be_kind_of Array
      assert_requested :get, github_url("/orgs/#{test_github_org}/projects")
    end
  end # .org_project

  describe '.create_org_project', :vcr do
    it 'returns the new org project' do
      project = oauth_client.create_org_project(test_github_org, 'synergy', body: 'do it')
      expect(project.name).to eq 'synergy'
      expect(project.body).to eq 'do it'
      assert_requested :post, github_url("/orgs/#{test_github_org}/projects")
    end
  end # .create_org_project

  context 'with repository' do
    before(:each) do
      delete_test_repo
    end

    after(:each) do
      delete_test_repo
    end

    context 'with project' do
      before(:each) do
        @project = oauth_client.create_project(@test_repo, 'implement apis')
      end

      describe '.project', :vcr do
        it 'returns a project' do
          project = oauth_client.project(@project.id)
          expect(project.name).not_to be_nil
          assert_requested :get, github_url("/projects/#{@project.id}")
        end
      end # .project

      describe '.update_project', :vcr do
        it 'updates the project name and body then returns the updated project' do
          name = 'new name'
          body = 'new body'
          project = oauth_client.update_project(@project.id, { name: name, body: body })
          expect(project.name).to eq name
          expect(project.body).to eq body
          assert_requested :patch, github_url("/projects/#{@project.id}")
        end
      end # .update_project

      describe '.delete_project', :vcr do
        it 'returns the result of deleting a project' do
          result = oauth_client.delete_project(@project.id)
          expect(result).to eq true
          assert_requested :delete, github_url("/projects/#{@project.id}")
        end
      end # .delete_project

      describe '.project_columns', :vcr do
        it 'returns the columns for a project' do
          columns = oauth_client.project_columns(@project.id)
          expect(columns).to be_kind_of Array
          assert_requested :get, github_url("/projects/#{@project.id}/columns")
        end
      end # .project_columns

      describe '.create_project_column', :vcr do
        it 'returns the newly created project column' do
          column = oauth_client.create_project_column(@project.id, 'Todos')
          expect(column.name).to eq 'Todos'
          assert_requested :post, github_url("/projects/#{@project.id}/columns")
        end
      end # .create_project_column

      context 'with project column' do
        before(:each) do
          @column = oauth_client.create_project_column(@project.id, "Todos #{Time.now.to_f}")
        end

        describe '.project_column', :vcr do
          it 'returns a project column by id' do
            column = oauth_client.project_column(@column.id)
            expect(column.name).to be_kind_of String
            assert_requested :get, github_url("/projects/columns/#{@column.id}")
          end
        end # .project_column

        describe '.update_project_column', :vcr do
          it 'updates the project column and returns the updated column' do
            column = oauth_client.update_project_column(@column.id, 'new name')
            expect(column.name).to eq 'new name'
            assert_requested :patch, github_url("/projects/columns/#{@column.id}")
          end
        end # .update_project_column

        describe '.move_project_column', :vcr do
          it 'moves the project column' do
            result = oauth_client.move_project_column(@column.id, 'last')
            expect(result).not_to be_nil
            assert_requested :post, github_url("/projects/columns/#{@column.id}/moves")
          end
        end # .move_project_column

        describe '.delete_project_column', :vcr do
          it 'deletes the project column' do
            result = oauth_client.delete_project_column(@column.id)
            expect(result).to eq true
            assert_requested :delete, github_url("/projects/columns/#{@column.id}")
          end
        end # .delete_project_column

        describe '.column_cards', :vcr do
          it 'returns a list of the cards in a project column' do
            cards = oauth_client.column_cards(@column.id)
            expect(cards).to be_kind_of Array
            assert_requested :get, github_url("/projects/columns/#{@column.id}/cards")
          end
        end # .column_cards

        describe '.create_project_card', :vcr do
          it 'creates a new card with a note' do
            card = oauth_client.create_project_card(@column.id, note: 'thing')
            expect(card.note).to eq 'thing'
            assert_requested :post, github_url("/projects/columns/#{@column.id}/cards")
          end
        end # .create_project_card

        context 'with project card' do
          before(:each) do
            @card = oauth_client.create_project_card(@column.id, note: 'octocard')
          end

          describe '.project_card', :vcr do
            it 'returns a project card by id' do
              card = oauth_client.project_card(@card.id)
              expect(card.note).to be_kind_of String
              assert_requested :get, github_url("/projects/columns/cards/#{@card.id}")
            end
          end # .project_card

          describe '.update_project_card', :vcr do
            it 'updates the project card' do
              card = oauth_client.update_project_card(@card.id, note: 'new note')
              expect(card.note).to eq 'new note'
              assert_requested :patch, github_url("/projects/columns/cards/#{@card.id}")
            end
          end # .update_project_card

          describe '.move_project_card', :vcr do
            it 'moves the project card' do
              result = oauth_client.move_project_card(@card.id, 'bottom')
              expect(result).not_to be_nil
              assert_requested :post, github_url("/projects/columns/cards/#{@card.id}/moves")
            end
          end # .move_project_card

          describe '.delete_project_card', :vcr do
            it 'deletes the project card' do
              success = oauth_client.delete_project_card(@card.id)
              expect(success).to eq true
              assert_requested :delete, github_url("/projects/columns/cards/#{@card.id}")
            end
          end # .delete_project_card
        end # with project card
      end # with project column
    end # with project
  end # with repository
end # Octokit::Client::Projects

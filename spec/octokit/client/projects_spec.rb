require 'helper'

describe Octokit::Client::Projects do

  describe ".projects", :vcr do
    it "returns a list of projects for a repository" do
      projects = oauth_client.projects('octokit/octokit.rb')
      expect(projects).to be_kind_of Array
      assert_requested :get, github_url("/repos/octokit/octokit.rb/projects")
    end
  end # .projects

  describe ".create_project", :vcr do
    it "returns the newly created project" do
      project = oauth_client.create_project(@test_repo, "api kpi")
      expect(project.name).to eq("api kpi")
      assert_requested :post, github_url("/repos/#{@test_repo}/projects")
    end
  end # .create_project

  context "with repository" do
    before(:each) do
      @repo = oauth_client.create_repository(test_github_repository)
    end

    after(:each) do
      begin
        oauth_client.delete_repository(@repo.full_name)
      rescue Octokit::NotFound
      end
    end

    context "with project" do
      before(:each) do
        @project = oauth_client.create_project(@repo.full_name, "implement apis")
      end

      describe ".project", :vcr do
        it "returns a project" do
          project = Octokit.project(@repo.full_name, @project.number)
          expect(project.name).not_to be_nil
          assert_requested :get, github_url("/repos/#{@repo.full_name}/projects/#{@project.number}")
        end
      end # .project

      describe ".update_project", :vcr do
        it "updates the project name and body then returns the updated project" do
          name = "new name"
          body = "new body"
          project = oauth_client.update_project(@repo.full_name, @project.number, {name: name, body: body})
          expect(project.name).to eq name
          expect(project.body).to eq body
          assert_requested :patch, github_url("/repos/#{@repo.full_name}/projects/#{@project.number}")
        end
      end # .update_project

      describe ".delete_project", :vcr do
        it "returns the result of deleting a project" do
          result = oauth_client.delete_project(@repo.full_name, @project.number)
          expect(result).to eq true
          assert_requested :delete, github_url("/repos/#{@repo.full_name}/projects/#{@project.number}")
        end
      end # .delete_project

      describe ".project_columns", :vcr do
        it "returns the columns for a project" do
          columns = Octokit.project_columns(@repo.full_name, @project.number)
          expect(columns).to be_kind_of Array
          assert_requested :get, github_url("/repos/#{@repo.full_name}/projects/#{@project.number}/columns")
        end
      end # .project_columns

      describe ".create_project_column", :vcr do
        it "returns the newly created project column" do
          column = oauth_client.create_project_column(@repo.full_name, @project.number, "Todos")
          expect(column.name).to eq "Todos"
          assert_requested :post, github_url("/repos/#{@repo.full_name}/projects/#{@project.number}/columns")
        end
      end # .create_project_column

      context "with project column" do
        before(:each) do
          @column = oauth_client.create_project_column(@repo.full_name, @project.number, 'Todos')
        end

        describe ".project_column", :vcr do
          it "returns a project column by id" do
            skip "pending api"
            column = oauth_client.project_column(@repo.full_name, @project.number, @column.id)
            expect(column.name).to be_kind_of String
            assert_requested :get, github_url("/repos/#{@repo.full_name}/projects/#{@projects.number}/columns/#{@column.id}")
          end
        end # .project_column

        describe ".update_project_column", :vcr do
          it "updates the project column and returns the updated column" do
            skip "pending api"
            column = oauth_client.update_project_column(@repo.full_name, @project.number, @column.id, "new name")
            expect(column.name).to eq "new name"
            assert_requested :patch, github_url("/repos/#{@repo.full_name}/projects/#{@project.number}/columns/#{@column.id}")
          end
        end # .update_project_column

        describe ".delete_project_column", :vcr do
          it "deletes the project column" do
            skip "pending api"
            result = oauth_client.delete_project_column(@repo.full_name, @project.number, @column.id)
            expect(result).to eq true
            assert_requested :delete, github_url("/repos/#{@repo.full_name}/projects/#{@project.number}/columns/#{@column.id}")
          end
        end # .delete_project_column

        describe ".move_project_column", :vcr do
          it "moves the project column" do
            skip "pending api"
            result = oauth_client.move_project_column(@repo.full_name, @project.number, @column.id, "last")
            expect(result).to eq true
            assert_requested :post, github_url("/repos/#{@repo.full_name}/projects/#{@project.number}/columns/#{@column.id}/moves")
          end
        end # .move_project_column

        describe ".projects_cards", :vcr do
          it "returns projects cards by column id" do
            skip "pending api"
            cards = oauth_client.projects_cards(@repo.full_name, @project.number, @column.id)
            expect(cards).to be_kind_of Array
            assert_requested :get, github_url("/repos/#{@repo.full_name}/projects/#{@project.number}/columns/#{@column.id}/cards")
          end
        end # .projects_cards

      end # with project column
    end # with project
  end # with repository
end # Octokit::Client::Projects

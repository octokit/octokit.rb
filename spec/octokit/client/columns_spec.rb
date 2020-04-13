require 'helper'

describe Octokit::Client::Columns do

  context "with repository" do
    context "with project" do
      before(:each) do
        @project = oauth_client.create_repo_project(@test_repo, "implement apis", accept: preview_header)
      end

      after(:each) do
        oauth_client.delete_project(@project.id, accept: preview_header)
      end

      describe ".project_columns", :vcr do
        it "returns the columns for a project" do
          columns = oauth_client.project_columns(@project.id, accept: preview_header)
          expect(columns).to be_kind_of Array
          assert_requested :get, github_url("/projects/#{@project.id}/columns")
        end
      end # .project_columns

      describe ".create_project_column", :vcr do
        it "returns the newly created project column" do
          column = oauth_client.create_project_column(@project.id, "Todos", accept: preview_header)
          expect(column.name).to eq "Todos"
          assert_requested :post, github_url("/projects/#{@project.id}/columns")
        end
      end # .create_project_column

      context "with project column" do
        before(:each) do
          @column = oauth_client.create_project_column(@project.id, "Todos #{Time.now.to_f}", accept: preview_header)
        end

        after(:each) do
          oauth_client.delete_project_column(@column.id, accept: preview_header)
        end

        describe ".project_column", :vcr do
          it "returns a project column by id" do
            column = oauth_client.project_column(@column.id, accept: preview_header)
            expect(column.name).to be_kind_of String
            assert_requested :get, github_url("/projects/columns/#{@column.id}")
          end
        end # .project_column

        describe ".update_project_column", :vcr do
          it "updates the project column and returns the updated column" do
            column = oauth_client.update_project_column(@column.id, "new name", accept: preview_header)
            expect(column.name).to eq "new name"
            assert_requested :patch, github_url("/projects/columns/#{@column.id}")
          end
        end # .update_project_column

        describe ".move_project_column", :vcr do
          it "moves the project column" do
            result = oauth_client.move_project_column(@column.id, "last", accept: preview_header)
            assert_requested :post, github_url("/projects/columns/#{@column.id}/moves")
            expect(result).to eq(true)
          end
        end # .move_project_column

        describe ".delete_project_column", :vcr do
          it "deletes the project column" do
            result = oauth_client.delete_project_column(@column.id, accept: preview_header)
            expect(result).to eq true
            assert_requested :delete, github_url("/projects/columns/#{@column.id}")
          end
        end # .delete_project_column
      end # with project column
    end # with project
  end # with repository

  private

  def preview_header
    Octokit::Preview::PREVIEW_TYPES[:projects]
  end
end

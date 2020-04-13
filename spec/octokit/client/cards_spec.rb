require 'helper'

describe Octokit::Client::Cards do

  context "with project column" do
    before(:each) do
      @project = oauth_client.create_repo_project(@test_repo, "implement apis", accept: preview_header)
      @column = oauth_client.create_project_column(@project.id, "Todos #{Time.now.to_f}", accept: preview_header)
    end

    after(:each) do
      oauth_client.delete_project_column(@column.id, accept: preview_header)
      oauth_client.delete_project(@project.id, accept: preview_header)
    end

    describe ".project_cards", :vcr do
      it "returns a list of the cards in a project column" do
        cards = oauth_client.project_cards(@column.id, accept: preview_header)
        expect(cards).to be_kind_of Array
        assert_requested :get, github_url("/projects/columns/#{@column.id}/cards")
      end
    end # .project_cards

    describe ".create_project_card", :vcr do
      it "creates a new card with a note" do
        card = oauth_client.create_project_card(@column.id, note: 'thing', accept: preview_header)
        expect(card.note).to eq 'thing'
        assert_requested :post, github_url("/projects/columns/#{@column.id}/cards")
      end
    end # .create_project_card

    context "with project card" do
      before(:each) do
        @card = oauth_client.create_project_card(@column.id, note: 'octocard', accept: preview_header)
      end

      after(:each) do
        oauth_client.delete_project_card(@card.id, accept: preview_header)
      end

      describe ".project_card", :vcr do
        it "returns a project card by id" do
          card = oauth_client.project_card(@card.id, accept: preview_header)
          expect(card.note).to be_kind_of String
          assert_requested :get, github_url("/projects/columns/cards/#{@card.id}")
        end
      end # .project_card

      describe ".update_project_card", :vcr do
        it "updates the project card" do
          card = oauth_client.update_project_card(@card.id, note: 'new note', accept: preview_header)
          expect(card.note).to eq 'new note'
          assert_requested :patch, github_url("/projects/columns/cards/#{@card.id}")
        end
      end # .update_project_card

      describe ".move_project_card", :vcr do
        it "moves the project card" do
          result = oauth_client.move_project_card(@card.id, 'bottom', accept: preview_header)
          assert_requested :post, github_url("/projects/columns/cards/#{@card.id}/moves")
          expect(result).to eq(true)
        end
      end # .move_project_card

      describe ".delete_project_card", :vcr do
        it "deletes the project card" do
          success = oauth_client.delete_project_card(@card.id, accept: preview_header)
          expect(success).to eq true
          assert_requested :delete, github_url("/projects/columns/cards/#{@card.id}")
        end
      end # .delete_project_card
    end # with project card
  end # with project column

  private

  def preview_header
    Octokit::Preview::PREVIEW_TYPES[:projects]
  end
end

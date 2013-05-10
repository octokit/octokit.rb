require 'helper'

describe Octokit::Client::Labels do

  before do
    Octokit.reset!
    VCR.insert_cassette 'labels'
    @client = basic_auth_client
  end

  after do
    Octokit.reset!
    VCR.eject_cassette
  end

  describe ".labels" do
    it "returns labels" do
      labels = Octokit.labels("pengwynn/octokit")
      expect(labels).to be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/labels")
    end
  end # .labels

  describe ".label" do
    it "returns a single label" do
      label = Octokit.label("pengwynn/octokit", "V3 Addition")
      expect(label.name).to eq "V3 Addition"
      assert_requested :get, github_url("/repos/pengwynn/octokit/labels/V3+Addition")
    end
  end # .label

  describe ".add_label" do
    it "adds a label with a color" do
      label = @client.add_label("api-playground/api-sandbox", "test-label", 'ededed')
      expect(label.color).to eq "ededed"
      assert_requested :post, basic_github_url("/repos/api-playground/api-sandbox/labels")
    end
    it "adds a label with default color" do
      label = @client.add_label("api-playground/api-sandbox", "test-label")
      assert_requested :post, basic_github_url("/repos/api-playground/api-sandbox/labels")
    end
  end # .add_label

  context "methods requiring a new label" do

    before do
      @label = @client.add_label("api-playground/api-sandbox", "test-label", 'ededed')
    end

    describe ".update_label" do
      it "updates a label with a new color" do
        @client.update_label("api-playground/api-sandbox", @label.name, {:color => 'ffdd33'})
        assert_requested :patch, basic_github_url("/repos/api-playground/api-sandbox/labels/#{@label.name}")
      end
    end # .update_label
  end

  context "methods requiring a new issue" do
    before do
      @issue = @client.create_issue("api-playground/api-sandbox", "Issue for label test", "The body")
    end

    describe ".add_labels_to_an_issue" do
      it "adds labels to a given issue" do
        labels = @client.add_labels_to_an_issue('api-playground/api-sandbox', @issue.number, ['bug'])
        assert_requested :post, basic_github_url("/repos/api-playground/api-sandbox/issues/#{@issue.number}" + "/labels")
      end
    end # .add_labels_to_an_issue

    describe ".labels_for_issue" do
      it "returns all labels for a given issue" do
        labels = @client.labels_for_issue('api-playground/api-sandbox', @issue.number)
        expect(labels).to be_kind_of Array
        assert_requested :get, basic_github_url("/repos/api-playground/api-sandbox/issues/#{@issue.number}/labels")
      end
    end # .labels_for_issue

    describe ".remove_label" do
      it "removes a label from the specified issue" do
        labels = @client.remove_label('api-playground/api-sandbox', @issue.number, 'bug')
        assert_requested :delete, basic_github_url("/repos/api-playground/api-sandbox/issues/#{@issue.number}" + "/labels/bug")
      end
    end # .remove_label

    describe ".remove_all_labels" do
      it "removes all labels from the specified issue" do
        labels = @client.remove_all_labels('api-playground/api-sandbox', @issue.number)
        assert_requested :delete, basic_github_url("/repos/api-playground/api-sandbox/issues/#{@issue.number}" + "/labels")
      end
    end # .remove_all_labels

    describe ".replace_all_labels" do
      it "replaces all labels for an issue" do
        labels = @client.replace_all_labels('api-playground/api-sandbox', @issue.number, ['bug', 'pdi'])
        assert_requested :put, basic_github_url("/repos/api-playground/api-sandbox/issues/#{@issue.number}" + "/labels")
      end
    end # .replace_all_labels
  end


  describe ".lables_for_milestone" do
    it "returns all labels for a repository" do
      labels = Octokit.labels_for_milestone('pengwynn/octokit', 2)
      expect(labels).to be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/milestones/2/labels")
    end
  end # .labels_for_milestone


  describe ".delete_label!" do
    it "deletes a label from the repository" do
      label = @client.add_label("api-playground/api-sandbox", "delete-me-label")
      @client.delete_label!("api-playground/api-sandbox", label.name, {:color => 'ededed'})
      assert_requested :delete, basic_github_url("/repos/api-playground/api-sandbox/labels/#{label.name}")
    end
  end # .delete_label!

end

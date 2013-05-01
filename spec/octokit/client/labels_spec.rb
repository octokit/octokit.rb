require File.expand_path('../../../spec_helper.rb', __FILE__)

describe Octokit::Client::Labels do

  before do
    Octokit.reset!
    VCR.insert_cassette 'labels'
  end

  after do
    Octokit.reset!
    VCR.eject_cassette
  end

  describe ".labels" do
    it "returns labels" do
      labels = Octokit.labels("pengwynn/octokit")
      labels.must_be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/labels")
    end
  end # .labels

  describe ".label" do
    it "returns a single label" do
      label = Octokit.label("pengwynn/octokit", "V3 Addition")
      label.name.must_equal "V3 Addition"
      assert_requested :get, github_url("/repos/pengwynn/octokit/labels/V3+Addition")
    end
  end # .label

  describe ".add_label" do
    it "adds a label with a color" do
      client = basic_auth_client
      label = client.add_label("pengwynn/api-sandbox", "test-label", 'ededed')
      label.color.must_equal "ededed"
      assert_requested :post, basic_github_url("/repos/pengwynn/api-sandbox/labels")
    end
    it "adds a label with default color" do
      client = basic_auth_client
      label = client.add_label("pengwynn/api-sandbox", "test-label")
      assert_requested :post, basic_github_url("/repos/pengwynn/api-sandbox/labels")
    end
  end # .add_label

  describe ".update_label" do
    it "updates a label with a new color" do
      client = basic_auth_client
      label = client.add_label("pengwynn/api-sandbox", "test-label")
      client.update_label("pengwynn/api-sandbox", label.name, {:color => 'ededed'})
      assert_requested :patch, basic_github_url("/repos/pengwynn/api-sandbox/labels/#{label.name}")
    end
  end # .update_label

  describe ".add_labels_to_an_issue" do
    it "adds labels to a given issue" do
      client = basic_auth_client
      issue = client.create_issue("pengwynn/api-sandbox", "Issue for label test", "The body")
      labels = client.add_labels_to_an_issue('pengwynn/api-sandbox', issue.number, ['bug'])
      assert_requested :post, basic_github_url("/repos/pengwynn/api-sandbox/issues/#{issue.number}" + "/labels")
    end
  end # .add_labels_to_an_issue


  describe ".remove_label" do
    it "removes a label from the specified issue" do
      client = basic_auth_client
      issue = client.create_issue("pengwynn/api-sandbox", "Issue for label test", "The body")
      labels = client.remove_label('pengwynn/api-sandbox', issue.number, 'bug')
      assert_requested :delete, basic_github_url("/repos/pengwynn/api-sandbox/issues/#{issue.number}" + "/labels/bug")
    end
  end # .remove_label

  describe ".remove_all_labels" do
    it "removes all labels from the specified issue" do
      client = basic_auth_client
      issue = client.create_issue("pengwynn/api-sandbox", "Issue for label test", "The body")
      labels = client.remove_all_labels('pengwynn/api-sandbox', issue.number)
      assert_requested :delete, basic_github_url("/repos/pengwynn/api-sandbox/issues/#{issue.number}" + "/labels")
    end
  end # .remove_all_labels

  describe ".replace_all_labels" do
    it "replaces all labels for an issue" do
      client = basic_auth_client
      issue = client.create_issue("pengwynn/api-sandbox", "Issue for label test", "The body")
      labels = client.replace_all_labels('pengwynn/api-sandbox', issue.number, ['bug', 'pdi'])
      assert_requested :put, basic_github_url("/repos/pengwynn/api-sandbox/issues/#{issue.number}" + "/labels")
    end
  end # .replace_all_labels

  describe ".lables_for_milestone" do
    it "returns all labels for a repository" do
      labels = Octokit.labels_for_milestone('pengwynn/octokit', 2)
      labels.must_be_kind_of Array
      assert_requested :get, github_url("/repos/pengwynn/octokit/milestones/2/labels")
    end
  end # .labels_for_milestone

  describe ".labels_for_issue" do
    it "returns all labels for a given issue" do
      labels = Octokit.labels_for_issue('pengwynn/octokit', 37)
      labels.must_be_kind_of Array
      assert_requested :get, github_url('/repos/pengwynn/octokit/issues/37/labels')
    end
  end # .labels_for_issue

  describe ".delete_label!" do
    it "deletes a label from the repository" do
      client = basic_auth_client
      label = client.add_label("pengwynn/api-sandbox", "test-label")
      client.delete_label!("pengwynn/api-sandbox", label.name, {:color => 'ededed'})
      assert_requested :delete, basic_github_url("/repos/pengwynn/api-sandbox/labels/#{label.name}")
    end
  end # .delete_label!

end

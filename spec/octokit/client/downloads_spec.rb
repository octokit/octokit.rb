# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Downloads do

  before do
    stub_get("https://api.github.com/").
      to_return(:body => fixture("v3/root.json"))
    stub_get("https://api.github.com/repos/sferik/rails_admin").
      to_return(:body => fixture("v3/repository.json"))
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".downloads" do

    it "lists available downloads" do
      stub_get("/repos/sferik/rails_admin/downloads").
        to_return(:body => fixture("v3/downloads.json"))
      downloads = @client.downloads("sferik/rails_admin")
      expect(downloads.first.description).to eq("Robawt")
    end

  end

  describe ".download" do

    it "gets a single download" do
      stub_get("/repos/sferik/rails_admin/downloads/165347").
        to_return(:body => fixture("v3/download.json"))
      download = @client.download("sferik/rails_admin", 165347)
      expect(download.id).to eq(165347)
      expect(download.name).to eq('hubot-2.1.0.tar.gz')
    end

  end

  describe ".create_download" do
    before(:each) do
      stub_request(:post, "https://api.github.com/repos/sferik/rails_admin/downloads").
        with(:body => "{\"description\":\"Description of your download\",\"content_type\":\"text/plain\",\"name\":\"download_create.json\",\"size\":688}",
            :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Octokit Ruby Gem 1.18.0'}).
        to_return(:body => fixture("v3/download_create.json"))
    end
    it "creates a download resource" do
      resource = @client.send(:create_download_resource, "sferik/rails_admin", "download_create.json", 688, {:description => "Description of your download", :content_type => "text/plain"})
      expect(resource.s3_url).to eq("https://github.s3.amazonaws.com/")
    end

    it "posts to an S3 url" do
      stub_post("https://github.s3.amazonaws.com/").
        to_return(:status => 201)
      file_path = File.expand_path 'spec/fixtures/v3/download_create.json'
      expect(@client.create_download("sferik/rails_admin", file_path, {:description => "Description of your download", :content_type => "text/plain"})).to eq(true)
    end
  end

  describe ".delete_download" do

    it "deletes a download" do
      stub_request(:delete, "https://api.github.com/repos/sferik/rails_admin/downloads/165347").
        with(:headers => {'Accept'=>'*/*'}).
        to_return(:status => 204, :body => "", :headers => {})
      expect(@client.delete_download('sferik/rails_admin', 165347)).to be_true
    end
  end

end

# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Repository do
  context "when passed a string containg a slash" do
    before do
      @repository = Octokit::Repository.new("sferik/octokit")
    end

    it "sets the repository name and username" do
      expect(@repository.name).to eq("octokit")
      expect(@repository.username).to eq("sferik")
    end

    it "responds to repo and user" do
      expect(@repository.repo).to eq("octokit")
      expect(@repository.user).to eq("sferik")
    end

    it "renders slug as string" do
      expect(@repository.slug).to eq("sferik/octokit")
      expect(@repository.to_s).to eq(@repository.slug)
    end

    it "renders url as string" do
      expect(@repository.url).to eq('https://github.com/sferik/octokit')
    end
  end

  describe ".path" do
    context "with named repository" do
      it "returns the url path" do
        repository = Octokit::Repository.new('sferik/octokit')
        expect(repository.path).to eq 'repos/sferik/octokit'
      end
    end

    context "with repository id" do
      it "returns theu url path" do
        repository = Octokit::Repository.new(12345)
        expect(repository.path).to eq 'repositories/12345'
      end
    end
  end # .path

  context "when passed an integer" do
    it "sets the repository id" do
      repository = Octokit::Repository.new(12345)
      expect(repository.id).to eq 12345
    end
  end

  context "when passed a hash" do
    it "sets the repository name and username" do
      repository = Octokit::Repository.new({:username => 'sferik', :name => 'octokit'})
      expect(repository.name).to eq("octokit")
      expect(repository.username).to eq("sferik")
    end
  end

  context "when passed a Repo" do
    it "sets the repository name and username" do
      repository = Octokit::Repository.new(Octokit::Repository.new('sferik/octokit'))
      expect(repository.name).to eq("octokit")
      expect(repository.username).to eq("sferik")
      expect(repository.url).to eq('https://github.com/sferik/octokit')
    end
  end

  context "when given a URL" do
    it "sets the repository name and username" do
      repository = Octokit::Repository.from_url("https://github.com/sferik/octokit")
      expect(repository.name).to eq("octokit")
      expect(repository.username).to eq("sferik")
    end
  end
end

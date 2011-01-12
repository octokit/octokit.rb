require File.expand_path('../helper', __FILE__)

describe Octokit::Repository do
  context "when passed a string containg a forward slash" do
    before do
      @respository = Octokit::Repository.new("sferik/octokit")
    end

    it "should set the username and repo name" do
      @respository.name.should == "octokit"
      @respository.username.should == "sferik"
    end

    it "should respond to user and repo" do
      @respository.repo.should == "octokit"
      @respository.user.should == "sferik"
    end

    it "should render slug as string" do
      @respository.slug.should == "sferik/octokit"
      @respository.to_s.should == @respository.slug
    end

    it "should render url as string" do
      @respository.url.should == 'https://github.com/sferik/octokit'
    end

  end

  context "when passed a hash" do
    it "should should set username and repo" do
      repo =  Octokit::Repository.new({:username => 'sferik', :name => 'octokit'})
      repo.name.should == "octokit"
      repo.username.should == "sferik"
    end
  end

  context "when passed a Repo" do
    it "should set username and repo" do
      repo =  Octokit::Repository.new(Octokit::Repository.new('sferik/octokit'))
      repo.name.should == "octokit"
      repo.username.should == "sferik"
    end
  end
end

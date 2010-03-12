require File.dirname(__FILE__) + '/helper'

class RepoTest < Test::Unit::TestCase
  context "when passed a string containg a forward slash" do
    setup do
      @repo = Octopussy::Repo.new("pengwynn/linkedin")
    end
    
    should "set the username and repo name" do
      @repo.name.should == "linkedin"
      @repo.username.should == "pengwynn"
    end
    
    should "repond to user and repo" do
      @repo.repo.should == "linkedin"
      @repo.user.should == "pengwynn"
    end
    
    should "render slug as string" do
      @repo.slug.should == "pengwynn/linkedin"
      @repo.to_s.should == @repo.slug
    end
    
    should "render url as string" do
      @repo.url.should == 'http://github.com/pengwynn/linkedin'
    end
    
  end
  
  context "when passed a hash" do

    should "should set username and repo" do
      repo =  Octopussy::Repo.new({:username => 'pengwynn', :name => 'linkedin'})
      repo.name.should == "linkedin"
      repo.username.should == "pengwynn"
    end
  end
  
  context "when passed a Repo" do

    should "set username and repo" do
      repo =  Octopussy::Repo.new( Octopussy::Repo.new('pengwynn/linkedin'))
      repo.name.should == "linkedin"
      repo.username.should == "pengwynn"
    end
  end

  
  
  
end

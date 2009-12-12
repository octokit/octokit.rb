require 'helper'

class TestRepo < Test::Unit::TestCase
  context "when passed a string containg a forward slash" do
    setup do
      @repo = Repo.new("pengwynn/linkedin")
    end
    
    should "set the username and repo name" do
      @repo.name.should == "linkedin"
      @repo.username.should == "pengwynn"
    end
    
    should "repond to user and repo" do
      @repo.repo.should == "linkedin"
      @repo.user.should == "pengwynn"
    end
    
  end
  
  context "when passed a hash" do

    should "should set username and repo" do
      repo = Repo.new({:username => 'pengwynn', :name => 'linkedin'})
      repo.name.should == "linkedin"
      repo.username.should == "pengwynn"
    end
  end
  
  context "when passed a Repo" do

    should "description" do
      repo = Repo.new(Repo.new('pengwynn/linkedin'))
      repo.name.should == "linkedin"
      repo.username.should == "pengwynn"
    end
  end
  
  
  
  
end
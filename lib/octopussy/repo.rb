class Repo
  attr_accessor :username, :name
  
  def initialize(repo)
    if repo.is_a?(String)
      repo = repo.split("/")
      @name = repo.pop
      @username = repo.pop
    elsif repo.is_a?(Repo)
      @username = repo.username
      @name = repo.name
    elsif repo.is_a?(Hash)
      @name = repo[:repo] ||= repo[:name]
      @username = repo[:username] ||= repo[:user]
    end
  end
  
  def slug
    "#{@username}/#{@name}"
  end
  
  def user
    @username
  end
  
  def repo
    @name
  end
  
  def user=(val)
    @username = val
  end
end
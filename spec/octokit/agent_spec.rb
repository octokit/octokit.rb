require 'helper'

describe Octokit::Agent do

  it "fetches the API root" do
    stub_get("https://api.github.com/").
      with(:headers => {'Accept'=>'*/*'}).
      to_return(:status => 200, :body => '{"user_url": "https://api.github/com/{login}"}', :headers => {})
    expect {
      agent = Octokit.agent
      root = agent.start
    }.not_to raise_exception
  end

end

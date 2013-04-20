require 'minitest/spec'
require 'minitest/autorun'
begin; require 'turn/autorun'; rescue LoadError; end
require 'octokit'

require 'webmock/minitest'
WebMock.disable_net_connect!(:allow => 'coveralls.io')

require 'vcr'
VCR.configure do |c|
  c.filter_sensitive_data("<GITHUB_LOGIN>") do
      ENV['OCTOKIT_TEST_GITHUB_LOGIN']
  end
  c.filter_sensitive_data("<GITHUB_PASSWORD>") do
      ENV['OCTOKIT_TEST_GITHUB_PASSWORD']
  end
  c.default_cassette_options = {
    :serialize_with => :syck,
    :decode_compressed_response => true,
    :record => :new_episodes
  }
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

def test_github_login
  ENV.fetch 'OCTOKIT_TEST_GITHUB_LOGIN'
end

def test_github_password
  ENV.fetch 'OCTOKIT_TEST_GITHUB_PASSWORD'
end

def stub_delete(url)
  stub_request(:delete, github_url(url))
end

def stub_get(url)
  stub_request(:get, github_url(url))
end

def stub_head(url)
  stub_request(:head, github_url(url))
end

def stub_patch(url)
  stub_request(:patch, github_url(url))
end

def stub_post(url)
  stub_request(:post, github_url(url))
end

def stub_put(url)
  stub_request(:put, github_url(url))
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def json_response(file)
  {
    :body => fixture(file),
    :headers => {
      :content_type => 'application/json; charset=utf-8'
    }
  }
end

def github_url(url)
  if url =~ /^http/
    url
  elsif @client && @client.basic_authenticated?
    "https://#{@client.login}:#{@client.instance_variable_get(:"@password")}@api.github.com#{url}"
  else
    "https://api.github.com#{url}"
  end
end

def basic_github_url(path, options = {})
  login = options.fetch(:login, test_github_login)
  password = options.fetch(:password, test_github_password)

  "https://#{login}:#{password}@api.github.com#{path}"
end

def basic_auth_client(login = test_github_login, password = test_github_password )
  client = Octokit.client
  client.login = test_github_login
  client.password = test_github_password

  client
end


require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'json'
require 'octokit'
require 'rspec'
require 'webmock/rspec'

WebMock.disable_net_connect!(:allow => 'coveralls.io')

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
end

require 'vcr'
VCR.configure do |c|
  c.configure_rspec_metadata!
  c.filter_sensitive_data("<GITHUB_LOGIN>") do
    test_github_login
  end
  c.filter_sensitive_data("<GITHUB_PASSWORD>") do
    test_github_password
  end
  c.filter_sensitive_data("<<ACCESS_TOKEN>>") do
    test_github_token
  end
  c.filter_sensitive_data("<GITHUB_CLIENT_ID>") do
    test_github_client_id
  end
  c.filter_sensitive_data("<GITHUB_CLIENT_SECRET>") do
    test_github_client_secret
  end
  c.define_cassette_placeholder("<GITHUB_TEST_ORGANIZATION>") do
    test_github_org
  end
  c.before_record do |interaction|
    interaction.request.body.force_encoding('utf-8')
    interaction.response.body.force_encoding('utf-8')
  end
  c.default_cassette_options = {
    :serialize_with             => :json,
    :decode_compressed_response => true,
    :record                     => ENV['TRAVIS'] ? :none : :once
  }
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

def test_github_login
  ENV.fetch 'OCTOKIT_TEST_GITHUB_LOGIN', 'api-padawan'
end

def test_github_password
  ENV.fetch 'OCTOKIT_TEST_GITHUB_PASSWORD', 'wow_such_password'
end

def test_github_token
  ENV.fetch 'OCTOKIT_TEST_GITHUB_TOKEN', 'x' * 40
end

def test_github_client_id
  ENV.fetch 'OCTOKIT_TEST_GITHUB_CLIENT_ID', 'x' * 21
end

def test_github_client_secret
  ENV.fetch 'OCTOKIT_TEST_GITHUB_CLIENT_SECRET', 'x' * 40
end

def test_github_org
  ENV.fetch 'OCTOKIT_TEST_GITHUB_ORGANIZATION', 'api-playground'
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
  url =~ /^http/ ? url : "https://api.github.com#{url}"
end

def basic_github_url(path, options = {})
  login = options.fetch(:login, test_github_login)
  password = options.fetch(:password, test_github_password)

  "https://#{login}:#{password}@api.github.com#{path}"
end

def basic_auth_client(username = test_github_login, password = test_github_password )
  Octokit::Client.new(:login => username, :password => password)
end

def oauth_client
  Octokit::Client.new(:access_token => test_github_token)
end


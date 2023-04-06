# frozen_string_literal: true

require 'octokit/error'

# I have mixed feelings about testing this method due to potentially breaking encapsulation but
# given the nature of this method and the fact that it is meant to keep secrets out of logs.
# In this case, it is worth it and will help us know if something changes in this area.
describe Octokit::Error do
  describe '.redact_url' do
    it 'redacts api_key' do
      url = 'http://127.0.0.1:8989/setup/api/settings?api_key=++++THIS+IS+A+SECRET++++&settings=certificate%22%2C%22key%22%3A%22++++THIS+IS+A+SECRET+AS+WELL++++%22%7D%7D'.dup
      error = Octokit::Error.new
      expect(error.send(:redact_url, url)).to eq('http://127.0.0.1:8989/setup/api/settings?api_key=(redacted)')
    end

    it 'redacts client_secret' do
      url = 'http://127.0.0.1:8989/setup/api/settings?client_secret=++++THIS+IS+A+SECRET++++'.dup
      error = Octokit::Error.new
      expect(error.send(:redact_url, url)).to eq('http://127.0.0.1:8989/setup/api/settings?client_secret=(redacted)')
    end

    it 'redacts access_token' do
      url = 'http://127.0.0.1:8989/setup/api/settings?access_token=++++THIS+IS+A+SECRET++++'.dup
      error = Octokit::Error.new
      expect(error.send(:redact_url, url)).to eq('http://127.0.0.1:8989/setup/api/settings?access_token=(redacted)')
    end
  end
end

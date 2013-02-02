# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Statuses do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".statuses" do

    it "lists commit statuses" do
      stub_get('https://api.github.com/repos/pengwynn/octokit/statuses/7d069dedd4cb56bf57760688657abd0e6b5a28b8').
        to_return(json_response('statuses.json'))
      statuses = @client.statuses('pengwynn/octokit', '7d069dedd4cb56bf57760688657abd0e6b5a28b8')
      expect(statuses.first.target_url).to eq('http://travis-ci.org/pengwynn/octokit/builds/2092930')
    end

  end

  describe ".create_status" do

    it "creates status" do
      stub_post('https://api.github.com/repos/pengwynn/octokit/statuses/7d069dedd4cb56bf57760688657abd0e6b5a28b8').
        to_return(json_response('status.json'))
      info = {
        :target_url => 'http://wynnnetherland.com'
      }
      status = @client.create_status('pengwynn/octokit', '7d069dedd4cb56bf57760688657abd0e6b5a28b8', 'success', info)
      expect(status.target_url).to eq('http://wynnnetherland.com')
    end

  end

  describe ".github_status" do

    it "returns the current system status" do
      stub_get('https://status.github.com/api/status.json').
        to_return(json_response('github_status.json'))
      github_status = @client.github_status
      expect(github_status.status).to eq('good')
    end

  end

  describe ".github_status_last_message" do

    it "returns the last human communication, status, and timestamp" do
      stub_get('https://status.github.com/api/last-message.json').
        to_return(json_response('github_status_last_message.json'))
      last_message = @client.github_status_last_message
      expect(last_message.body).to eq('Everything operating normally.')
    end

  end

  describe ".github_status_messages" do

    it "returns the most recent human communications" do
      stub_get('https://status.github.com/api/messages.json').
        to_return(json_response('github_status_messages.json'))
      status_messages = @client.github_status_messages
      expect(status_messages.first.body).to eq("I'm seeing, like, unicorns man.")
    end

  end

end

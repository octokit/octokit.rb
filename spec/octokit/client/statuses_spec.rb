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

end

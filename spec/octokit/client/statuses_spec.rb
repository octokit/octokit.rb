# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Statuses do

  before do
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe '.statuses' do

    it 'should list commit statuses' do
      stub_get('https://api.github.com/repos/pengwynn/octokit/statuses/7d069dedd4cb56bf57760688657abd0e6b5a28b8').
        to_return(:body => fixture('v3/statuses.json'))
      statuses = @client.statuses('pengwynn/octokit', '7d069dedd4cb56bf57760688657abd0e6b5a28b8')
      statuses.first.target_url.should == 'http://travis-ci.org/pengwynn/octokit/builds/2092930'
    end

  end

  describe '.create_status' do

    it 'should create status' do
      stub_post('https://api.github.com/repos/pengwynn/octokit/statuses/7d069dedd4cb56bf57760688657abd0e6b5a28b8').
        to_return(:body => fixture('v3/status.json'))
      info = {
        :target_url => 'http://wynnnetherland.com'
      }
      status = @client.create_status('pengwynn/octokit', '7d069dedd4cb56bf57760688657abd0e6b5a28b8', 'success', info)
      status.target_url.should == 'http://wynnnetherland.com'
    end

  end

end

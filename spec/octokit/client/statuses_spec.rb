# -*- encoding: utf-8 -*-
require 'helper'

describe Octokit::Client::Statuses do

  before do
    stub_get("https://api.github.com/").
      to_return(:body => fixture("v3/root.json"))
    stub_get("https://api.github.com/repos/sferik/rails_admin").
      to_return(:body => fixture("v3/repository.json"))
    @client = Octokit::Client.new(:login => 'sferik')
  end

  describe ".statuses" do

    it "lists commit statuses" do
      stub_get('https://api.github.com/repos/sferik/rails_admin/statuses/7d069dedd4cb56bf57760688657abd0e6b5a28b8').
        to_return(:body => fixture('v3/statuses.json'))
      statuses = @client.statuses('sferik/rails_admin', '7d069dedd4cb56bf57760688657abd0e6b5a28b8')
      expect(statuses.first.target_url).to eq('http://travis-ci.org/sferik/rails_admin/builds/2092930')
    end

  end

  describe ".create_status" do

    it "creates status" do
      stub_post('https://api.github.com/repos/sferik/rails_admin/statuses/7d069dedd4cb56bf57760688657abd0e6b5a28b8').
        to_return(:body => fixture('v3/status.json'))
      info = {
        :target_url => 'http://wynnnetherland.com'
      }
      status = @client.create_status('sferik/rails_admin', '7d069dedd4cb56bf57760688657abd0e6b5a28b8', 'success', info)
      expect(status.target_url).to eq('http://wynnnetherland.com')
    end

  end

end

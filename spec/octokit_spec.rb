require 'helper'

describe Octokit do
  before do
    Octokit.reset!
  end

  after do
    Octokit.reset!
  end

  it "sets defaults" do
    Octokit::Configurable.keys.each do |key|
      expect(Octokit.instance_variable_get(:"@#{key}")).to eq(Octokit::Default.send(key))
    end
  end

  describe ".client" do
    it "creates an Octokit::Client" do
      expect(Octokit.client).to be_kind_of Octokit::Client
    end
    it "caches the client when the same options are passed" do
      expect(Octokit.client).to eq(Octokit.client)
    end
    it "returns a fresh client when options are not the same" do
      client = Octokit.client
      Octokit.access_token = "87614b09dd141c22800f96f11737ade5226d7ba8"
      client_two = Octokit.client
      client_three = Octokit.client
      expect(client).not_to eq(client_two)
      expect(client_three).to eq(client_two)
    end
  end

  describe ".configure" do
    Octokit::Configurable.keys.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        Octokit.configure do |config|
          config.send("#{key}=", key)
        end
        expect(Octokit.instance_variable_get(:"@#{key}")).to eq(key)
      end
    end

    it "it supports deprecated middleware namespaces" do
      builder_class = Octokit::Default::RACK_BUILDER_CLASS

      stack = builder_class.new do |builder|
        builder.use Octokit::Middleware::FollowRedirects
        builder.use Octokit::Response::RaiseError
        builder.use Octokit::Response::FeedParser
        builder.adapter Faraday.default_adapter
      end
    end

    it "it defines a default stack" do
      builder_class = Octokit::Default::RACK_BUILDER_CLASS

      stack = builder_class.new do |builder|
        builder.use Octokit::Middleware::RaiseError
        builder.use Octokit::Middleware::FollowRedirects
        builder.use Octokit::Middleware::FeedParser
        builder.adapter Faraday.default_adapter
      end

      expect(Octokit.middleware).to eq(stack)
    end
  end

end

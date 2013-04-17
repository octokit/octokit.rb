require 'spec_helper'

describe Octokit do

  describe ".client" do
    it "creates an Octokit::Client" do
      Octokit.client.must_be_kind_of Octokit::Client
    end
    it "caches the client when the same options are passed" do
      Octokit.client.must_equal Octokit.client
    end
    it "returns a fresh client when options are not the same" do
      client = Octokit.client
      Octokit.access_token = "87614b09dd141c22800f96f11737ade5226d7ba8"
      client_two = Octokit.client
      client_three = Octokit.client
      client.wont_equal client_two
      client_three.must_equal client_two
    end
  end

  describe ".configure" do
    Octokit::Configurable.keys.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        Octokit.configure do |config|
          config.send("#{key}=", key)
        end
        Octokit.instance_variable_get(:"@#{key}").must_equal key
      end
    end
  end

end

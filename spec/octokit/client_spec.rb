require File.expand_path('../../spec_helper.rb', __FILE__)

describe Octokit::Client do

  describe "module configuration" do

    before do
      Octokit.configure do |config|
        Octokit::Configurable.keys.each do |key|
          config.send("#{key}=", "Some #{key}")
        end
      end
    end

    after do
      Octokit.reset!
    end

    it "inherits the module configuration" do
      client = Octokit::Client.new
      Octokit::Configurable.keys.each do |key|
        client.instance_variable_get(:"@#{key}").must_equal "Some #{key}"
      end
    end

    describe "with class level configuration" do

      before do
        @opts = {
          :per_page => 40,
          :login    => "defunkt",
          :password => "il0veruby"
        }
      end

      it "overrides module configuration" do
        client = Octokit::Client.new(@opts)
        client.per_page.must_equal 40
        client.login.must_equal "defunkt"
        client.instance_variable_get(:"@password").must_equal "il0veruby"
        client.auto_paginate.must_equal Octokit.auto_paginate
        client.client_id.must_equal Octokit.client_id
      end

      it "can set configuration after initialization" do
        client = Octokit::Client.new
        client.configure do |config|
          @opts.each do |key, value|
            config.send("#{key}=", value)
          end
        end
        client.per_page.must_equal 40
        client.login.must_equal "defunkt"
        client.instance_variable_get(:"@password").must_equal "il0veruby"
        client.auto_paginate.must_equal Octokit.auto_paginate
        client.client_id.must_equal Octokit.client_id
      end

      it "masks passwords on inspect" do
        client = Octokit::Client.new(@opts)
        inspected = client.inspect
        inspected.wont_match "il0veruby"
      end

      it "masks tokens on inspect" do
        client = Octokit::Client.new(:access_token => '87614b09dd141c22800f96f11737ade5226d7ba8')
        inspected = client.inspect
        inspected.wont_match "87614b09dd141c22800f96f11737ade5226d7ba8"
      end

      it "masks client secrets on inspect" do
        client = Octokit::Client.new(:client_secret => '87614b09dd141c22800f96f11737ade5226d7ba8')
        inspected = client.inspect
        inspected.wont_match "87614b09dd141c22800f96f11737ade5226d7ba8"
      end
    end
  end

  describe "#agent" do
    before do
      Octokit.reset!
    end

    it "acts like a Sawyer agent" do
      Octokit.client.agent.must_respond_to :start
    end

    it "caches the agent" do
      agent = Octokit.client.agent
      agent.object_id.must_equal Octokit.client.agent.object_id
    end
  end
end

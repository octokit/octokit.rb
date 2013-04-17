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

  end

end

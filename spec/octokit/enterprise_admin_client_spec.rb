require 'helper'

describe Octokit::EnterpriseAdminClient do

  describe "module configuration" do

    it "inherits Octokit::Client" do
      admin_client = Octokit::EnterpriseAdminClient.new
      expect admin_client.is_a? Octokit::Client
    end

  end

end

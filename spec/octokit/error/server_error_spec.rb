require 'helper'

describe Octokit::Error::ServerError do

  before do
    @client = Octokit::Client.new
  end

  Octokit::Error::ServerError.errors.each do |status, exception|
    context "when HTTP status is #{status}" do
      before do
        stub_get("/").to_return(:status => status)
      end
      it "raises #{exception.name}" do
        expect{@client.root}.to raise_error exception
      end
    end
  end

end

require 'helper'
require 'json'

describe Octokit::Error::ClientError do

  before do
    @client = Octokit::Client.new
  end

  Octokit::Error::ClientError.errors.each do |status, exception|
    [nil, "error", "message"].each do |body|
      context "when HTTP status is #{status} and body is #{body.inspect}" do
        before do
          body_message = '{"' + body + '":"Client Error"}' unless body.nil?
          stub_get("/").to_return(:status => status, :body => body_message)
        end
        it "raises #{exception.name}" do
          expect{@client.root}.to raise_error exception
        end
      end
    end
    context "when HTTP status is #{status} and body is an errors hash" do
      before do
        body_message = {
          :message => "There was a problem",
          :errors  => [{
            :resource => "Issue",
            :field    => "title",
            :code     => "missing_field"
          }]
        }.to_json
        stub_get("/").to_return(:status => status, :body => body_message)
      end
      it "raises #{exception.name}" do
        expect{@client.root}.to raise_error exception
      end
    end
  end

end

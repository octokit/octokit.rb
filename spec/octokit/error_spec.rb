# -*- encoding: utf-8 -*-
require 'helper'
require 'json'

describe Octokit::Error do

  describe "#initialize" do
    it "wraps another error class" do
      begin
        raise Faraday::Error::ClientError.new("Boom")
      rescue Faraday::Error::ClientError
        begin
          raise Octokit::Error
        rescue Octokit::Error => error
          expect(error.message).to eq "Boom"
          expect(error.wrapped_exception.class).to eq Faraday::Error::ClientError
        end
      end
    end
  end

  describe "#from_response" do
    before do
      response = {
        :method => :get,
        :url => "https://api.github.com/user",
        :status => 500,
        :body => {"message" => "Server error"}.to_json
      }
      klass = Octokit::Error::ServerError.errors[500]
      @error = klass.from_response(response)
    end

    it "parses the message from HTTP response" do
      expect(@error.to_s).to include("Server error")
    end
  end

end

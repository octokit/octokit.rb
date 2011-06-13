# -*- encoding: utf-8 -*-
require 'helper'

describe Faraday::Response do
  before do
    @client = Octokit::Client.new
  end

  {
    400 => Octokit::BadRequest,
    401 => Octokit::Unauthorized,
    403 => Octokit::Forbidden,
    404 => Octokit::NotFound,
    406 => Octokit::NotAcceptable,
    500 => Octokit::InternalServerError,
    501 => Octokit::NotImplemented,
    502 => Octokit::BadGateway,
    503 => Octokit::ServiceUnavailable,
  }.each do |status, exception|
    context "when HTTP status is #{status}" do

      before do
        stub_get('user/show/sferik').
          to_return(:status => status)
      end

      it "should raise #{exception.name} error" do
        lambda do
          @client.user('sferik')
        end.should raise_error(exception)
      end
    end
  end

  context "when response[:body][:error] is a string" do

    before do
      stub_get('user/show/sferik').
        to_return(:status => 403, :body=>"{\"error\":\"error\"}")
    end

    it "should raise exception without error" do
      lambda do
        @client.user('sferik')
      end.should raise_error(Octokit::Forbidden)
    end
  end

  context "when response[:body][:error] is an array" do

    before do
      stub_get('user/show/sferik').
        to_return(:status => 403, :body=>"{\"error\":[\"a\",\"v\"]}")
    end

    it "should raise exception without error" do
      lambda do
        @client.user('sferik')
      end.should raise_error(Octokit::Forbidden)
    end
  end
end

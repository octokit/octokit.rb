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
    422 => Octokit::UnprocessableEntity,
    500 => Octokit::InternalServerError,
    501 => Octokit::NotImplemented,
    502 => Octokit::BadGateway,
    503 => Octokit::ServiceUnavailable,
  }.each do |status, exception|
    context "when HTTP status is #{status}" do

      before do
        stub_get('https://api.github.com/users/sferik').
          to_return(:status => status)
      end

      it "raises #{exception.name} error" do
        expect {
          @client.user('sferik')
        }.to raise_error(exception)
      end
    end
  end

  [
    {:message => "Problems parsing JSON"},
    {:error => "Body should be a JSON Hash"}
  ].each do |body|
    context "when the response body contains an error message" do

      before do
        stub_get('https://api.github.com/users/sferik').
          to_return(:status => 400, :body => body)
      end

      it "raises an error with the error message" do
        expect {
          @client.user('sferik')
        }.to raise_error(Octokit::BadRequest, /#{body.values.first}/)
      end
    end
  end

  {
    ['etag', :etag] => '"5999a524d53874f13d57f70a5b4bd1a6"',
    ['last-modified', :last_modified] => '"Mon, 10 Dec 2012 18:30:20 GMT',
    ['x-ratelimit-limit', :rate_limit] => 60,
    ['x-ratelimit-remaining', :rate_remaining] => 54
  }.each do |(header_name, header_method), header_value|
    context "when conditional header is present in response" do

      before do
        stub_get('https://api.github.com/users/sferik').
          to_return(:headers => { header_name => header_value },
                    :body => json_response("user.json"))
      end

      it "adds version to response hash" do
        response = @client.user 'sferik'
        expect(response.send header_method).to eq(header_value)
      end
    end
  end
end

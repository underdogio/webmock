require 'spec_helper'
require 'acceptance/webmock_shared'
require 'ostruct'

require 'acceptance/httpclient/httpclient_spec_helper'

describe "HTTPClient" do
  include HTTPClientSpecHelper

  before(:each) do
    HTTPClientSpecHelper.async_mode = false
  end

  include_examples "with WebMock"

  it "should yield block on response if block provided" do
    stub_request(:get, "www.example.com").to_return(:body => "abc")
    response_body = ""
    http_request(:get, "http://www.example.com/") do |body|
      response_body = body
    end
    response_body.should == "abc"
  end

  it "should match requests if headers are the same  but in different order" do
    stub_request(:get, "www.example.com").with(:headers => {"a" => ["b", "c"]} )
    http_request(
      :get, "http://www.example.com/",
    :headers => {"a" => ["c", "b"]}).status.should == "200"
  end

  describe "when using async requests" do
    before(:each) do
      HTTPClientSpecHelper.async_mode = true
    end

    include_examples "with WebMock"
  end
end

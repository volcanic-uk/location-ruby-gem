# frozen_string_literal: true

require "volcanic/location/version"

RSpec.describe Volcanic::Location::Connection do
  let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
  let(:middleware) {}
  let(:base_url) { Volcanic::Location.configure.domain_url }
  let(:conn) do
    Faraday.new(base_url) do |connection|
      connection.adapter(:test, stubs)
      connection.use middleware
    end
  end

  let(:status) { 200 }
  let(:headers) { { "Content-Type" => "application/json" } }
  let(:body) { { foo: "bar" } }
  let(:response) { [status, headers, body.to_s] }

  subject do
    stubs.get("/foobar") do |env|
      expect(env.url.path).to eq("/foobar")
      response
    end
    conn.get("/foobar")
  end

  describe "when using User-Agent middleware" do
    let(:middleware) { Volcanic::Location::Middleware::UserAgent }
    it("should content User-Agent header") do
      expect(subject.env[:request_headers]).to eq("User-Agent" => "Location v#{Volcanic::Location::VERSION}")
    end
  end

  describe "when using RequestId middleware" do
    let(:middleware) { Volcanic::Location::Middleware::RequestId }
    it("should content x-request-id header") do
      expect(subject.env[:request_headers]["x-request-id"]).to be_truthy
    end
  end
end

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

  # describe "when using User-Agent middleware" do
  #   let(:middleware) { Faraday::Response::Logger }
  #   it("should content User-Agent header") do
  #     expect(subject.env[:request_headers]).to eq("User-Agent" => "Faraday v1.10.2")
  #   end
  # end
end

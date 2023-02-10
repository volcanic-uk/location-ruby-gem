# frozen_string_literal: true

require "volcanic/location/version"

RSpec.describe Volcanic::Location::V1::Search do
  let(:conn) { Volcanic::Location::Connection }

  let(:response_body) { { locations: [{ "name": "test", "id": 1234 }, { "name": "test2", "id": 1236 }] } }
  let(:response) { double "response" }
  let(:api_path) { "api/v1/locations" }

  let(:filter) { { 'name': "test" } }

  subject(:instance) do
    described_class.new(**filter)
  end

  before do
    allow(response).to receive(:body).and_return(response_body)
    allow_any_instance_of(conn).to receive(:get).with(api_path).and_return(response)
  end

  describe "search" do
    it "Should return locations" do
      expect(instance.locations).to eq([{ "name": "test", "id": 1234 }, { "name": "test2", "id": 1236 }])
    end
    context "when no filter" do
      let(:filter) {}
      it "Should raise error" do
        expect { instance }.to raise_error(TypeError)
      end
    end
  end
end

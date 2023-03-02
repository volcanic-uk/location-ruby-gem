# frozen_string_literal: true

require "json"

RSpec.describe Volcanic::Location::V1::Location do
  let(:conn) { Volcanic::Location::Connection }

  let(:response_body) do
    {
      id: 1,
      name: "Example Location",
      geonames_id: 1,
      asciiname: "Example Location",
      alternatenames: "Example Location",
      latitude: 0.0,
      coordinate: 0.0,
      feature_class: "A",
      feature_code: "ADM1",
      country_code: "US",
      admin1: "US-CA",
      admin2: nil,
      admin3: nil,
      admin4: nil,
      timezone: "America/Los_Angeles",
      population: 0,
      modification_date: "2022-01-01T01:00:00Z",
      parent_id: nil,
      admin1_name: "California",
      descendants_id: [],
      hide: false
    }
  end

  let(:location_params) do
    {
      id: 1,
      name: "incorrect name",
      geonames_id: 1,
      asciiname: "Example Location",
      alternatenames: "Example Location",
      latitude: 0.0,
      coordinate: 0.0,
      feature_class: "A",
      feature_code: "ADM1",
      country_code: "US",
      admin1: "US-CA",
      admin2: nil,
      admin3: nil,
      admin4: nil,
      timezone: "America/Los_Angeles",
      population: 0,
      modification_date: "2022-01-01T01:00:00Z",
      parent_id: nil,
      admin1_name: "California",
      descendants_id: [],
      hide: false
    }
  end

  let(:response) { double "response" }

  subject(:location) do
    described_class.new(location_params)
  end

  before do
    allow(response).to receive(:body).and_return(response_body)
    allow_any_instance_of(conn).to receive(:get).with("api/v1/locations/1").and_return(response)
    allow_any_instance_of(conn).to receive(:delete).with("api/v1/locations/1").and_return(response)
    allow_any_instance_of(conn).to receive(:post).with("api/v1/locations", body: anything).and_return(response)
  end

  describe "#read" do
    it "returns a location" do
      expect(subject.name).to eq("incorrect name")
      subject.read
      expect(subject.name).to eq("Example Location")
    end
  end

  describe "#create" do
    new_location_params = {
        name: "New Location",
        geonames_id: 1234,
        asciiname: "New Location",
        alternatenames: "New Location",
        latitude: 0.0,
        coordinate: 0.0,
        feature_class: "A",
        feature_code: "ADM1",
        country_code: "US",
        admin1: "US-CA",
        admin2: nil,
        admin3: nil,
        admin4: nil,
        timezone: "America/Los_Angeles",
        population: 0,
        modification_date: "2022-01-01T01:00:00Z",
        parent_id: nil,
        admin1_name: "California",
        descendants_id: [],
        hide: false
    }
    before do
      allow(response).to receive(:body).and_return(new_location_params)
    end
    it "creates a new location" do
      location = described_class.new(described_class.create(new_location_params))
      expect(location.name).to eq("New Location")
    end
  end

  describe "#create_with_geonames" do
    
    it "creates a new location from a Geonames ID" do
      geonames_params = {
        geonames_id: 1234,
        fetch_from_geonames: true
      }
      location = described_class.new(described_class.create_with_geonames(geonames_params))
      expect(location.name).to eq( "Example Location" )
    end
  end
  describe "#save" do
    let(:request_body) { Hash[Volcanic::Location::V1::Location::UPDATABLE_ATTR.map { |attr| [attr, subject.send(attr)] }] }
    let(:mock_name) { "updated_name" }

    it "saves the location" do
      expect(subject.name).to eq("incorrect name")
      expect_any_instance_of(conn).to receive(:post).with("api/v1/locations/1", body: { **request_body, name: mock_name }).and_return(response)
      subject.name = mock_name
      subject.save
      expect(subject.name).to eq mock_name
    end
  end

  describe "#delete" do
    it "deletes the location" do
      expect_any_instance_of(conn).to receive(:delete).with("api/v1/locations/#{subject.id}").and_return(response)
      subject.delete
    end
  end
end

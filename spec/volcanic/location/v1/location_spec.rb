RSpec.describe Volcanic::Location::V1::Location do
  let(:conn) { Volcanic::Location::Connection }

  let(:response_body) {{
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
  }}

  let(:location_params) {{
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
  }}

  let(:response) { double "response" }

  subject(:location) do
    described_class.new(location_params)
  end

  before do
    allow(response).to receive(:body).and_return(response_body)
    allow_any_instance_of(conn).to receive(:get).with("api/v1/locations/1").and_return(response)
    allow_any_instance_of(conn).to receive(:delete).with("api/v1/locations/1").and_return(response)
  end

  describe "#read" do
    it "returns a location" do
      expect(subject.name).to eq("incorrect name")
      subject.read
      expect(subject.name).to eq("Example Location")
    end
  end

  describe "#save" do
    let(:request_body) { Hash[Volcanic::Location::V1::Location::UPDATABLE_ATTR.map { |attr| [attr, subject.send(attr)] }] }
    let(:request) {double "request"}

    before do
      allow_any_instance_of(conn).to receive(:post).with("api/v1/locations/1", request_body).and_return(request)
    end
    it "saves the location" do
      subject.save
      expect(conn).to have_received(:post).with("api/v1/locations", request_body)
    end
  end

  describe "#delete" do
    it "deletes the location" do
      expect(conn).to receive(:delete).with("api/v1/locations/#{subject.id}")
      subject.delete
      
    end
  end
end

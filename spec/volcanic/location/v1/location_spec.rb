RSpec.describe Volcanic::Location::V1::Location do
    let(:conn) { Volcanic::Location::Connection }
    let(:location_params) {{
      id: 1,
      name: "Example Location",
      geonames_id: 12345,
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
    
    describe "#initialize" do
      it "creates a new location object" do
        location = Volcanic::Location::V1::Location.new(location_params)
        expect(location).to be_a(Volcanic::Location::V1::Location)
      end
    end
  
    describe "#read" do
      it "reads a location" do
        allow(conn).to receive(:get).and_return("{\"name\":\"Example Location\",\"id\":1}")
        location = Volcanic::Location::V1::Location.new(location_params)
        location.read
        expect(location.name).to eq("Example Location")
        expect(location.geonames_id).to eq(12345)
      end
    end
  
    describe "#save" do
      it "saves a location" do
        allow(conn).to receive(:post).and_return("{\"name\":\"Example Location\",\"id\":1}")
        location = Volcanic::Location::V1::Location.new(location_params)
        location.save
        expect(location.name).to eq("Example Location")
        expect(location.geonames_id).to eq(12345)
      end
    end
  
    describe "#delete" do
      it "deletes a location" do
        allow(conn).to receive(:delete).and_return("{\"name\":\"Example Location\",\"id\":1}")
        location = Volcanic::Location::V1::Location.new(location_params)
        location.delete
      end
    end
  end
  
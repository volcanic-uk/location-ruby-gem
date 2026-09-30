# frozen_string_literal: true

require 'volcanic/location/exception'

RSpec.describe Volcanic::Location::V1::Api do
  let(:conn) { Volcanic::Location::Connection }
  let(:response) { double 'response' }

  describe '.geonames_preview' do
    let(:geonames_id) { '2643743' }
    let(:response_body) do
      {
        chain: [
          { source_id: 2_635_167, name: { en: 'United Kingdom' }, feature_code: 'PCLI', exists: true },
          { source_id: 2_643_743, name: { en: 'London' }, feature_code: 'PPLC', exists: false }
        ]
      }
    end

    before do
      allow(response).to receive(:body).and_return(response_body)
      allow_any_instance_of(conn).to receive(:get)
        .with("api/v1/locations/geonames_preview/#{geonames_id}").and_return(response)
    end

    it 'returns the preview body' do
      expect(described_class.geonames_preview(geonames_id)).to eq(response_body)
    end

    it 'accepts an integer id' do
      allow_any_instance_of(conn).to receive(:get)
        .with('api/v1/locations/geonames_preview/2643743').and_return(response)

      expect(described_class.geonames_preview(2_643_743)).to eq(response_body)
    end

    it 'raises when geonames_id is missing' do
      expect { described_class.geonames_preview(nil) }
        .to raise_error(Volcanic::Location::LocationError, 'geonames_id is required')
      expect { described_class.geonames_preview('') }
        .to raise_error(Volcanic::Location::LocationError, 'geonames_id is required')
    end
  end
end

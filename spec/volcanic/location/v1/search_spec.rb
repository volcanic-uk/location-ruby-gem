# frozen_string_literal: true

require 'volcanic/location/version'

RSpec.describe Volcanic::Location::V1::Search do
  let(:conn) { Volcanic::Location::Connection }
  let(:loc_instance) { Volcanic::Location::V1::Location }

  let(:mock_locs) do
    [
      { "source_type": 'test', "source_id": 1234 },
      { "source_type": 'test', "source_id": 1236 }
    ]
  end
  let(:response_body) { { locations: mock_locs } }
  let(:response) { double 'response' }
  let(:api_path) { 'api/v1/advanced_search' }

  let(:filter) { { 'name': 'test' } }

  subject(:instance) do
    described_class.new(**filter)
  end

  before do
    allow(response).to receive(:body).and_return(response_body)
    allow_any_instance_of(conn).to receive(:get).with(api_path).and_return(response)
  end

  describe 'search' do
    it 'Should return locations' do
      expect(instance.locations[0]).to be_a loc_instance
      expect(instance.locations[1]).to be_a loc_instance
    end
    context 'when no filter' do
      let(:filter) {}
      it 'Should raise error' do
        expect { instance }.to raise_error(TypeError)
      end
    end
  end
end

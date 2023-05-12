# frozen_string_literal: true

require 'volcanic/location/version'
require 'volcanic/location/exception.rb'

RSpec.describe Volcanic::Location::V1::Show do
  let(:conn) { Volcanic::Location::Connection }
  let(:loc_instance) { Volcanic::Location::V1::Location }

  let(:mock_loc) do
    { "source_type": 'test', "source_id": 1234, "asciiname": 'testCity' }
  end
  let(:response_body) { mock_loc }
  let(:response) { double 'response' }
  let(:api_path) {}

  let(:mock_source) { 'test' }
  let(:mock_id) { '1234' }

  subject(:instance) do
    described_class.new(mock_source, mock_id)
  end

  before do
    allow(response).to receive(:body).and_return(response_body)
    allow_any_instance_of(conn).to receive(:get).with(api_path).and_return(response)
  end

  describe 'show' do
    let(:api_path) { "api/v1/locations/#{mock_source}-#{mock_id}" }

    it 'Should return a location' do
      expect(instance.location).to be_a loc_instance
    end
    context 'when no id' do
      let(:mock_id) {}
      let(:mock_source) {}
      it 'Should raise error' do
        expect { instance }.to raise_error(Volcanic::Location::LocationError)
      end
    end
  end
end

# frozen_string_literal: true

require 'volcanic/location/version'
require 'stringio'

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
  let(:response) { instance_double(Faraday::Response, status: 200, body: response_body) }
  let(:api_path) { 'api/v1/advanced_search' }

  let(:filter) { { 'name': 'test' } }

  subject(:instance) do
    described_class.new(**filter)
  end

  before do
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

  describe 'logging' do
    let(:log_io) { StringIO.new }
    let(:log_output) { log_io.tap(&:rewind).read }

    before do
      allow_any_instance_of(described_class).to receive(:logger).and_return(Logger.new(log_io))
    end

    it 'logs a single summary line' do
      allow(Process).to receive(:clock_gettime).with(Process::CLOCK_MONOTONIC).and_return(100.0, 100.25)
      instance
      expect(log_output.lines.size).to eq(1)
      expect(log_output).to include(
        'Location-ruby-gem Search result: status=200 count=2 duration_ms=250 ' \
        'path=api/v1/advanced_search params={"name":"test"}'
      )
    end

    context 'when the response inspect contains credentials' do
      let(:mock_locs) do
        [
          { "source_type": 'test', "source_id": 1234, "name": { "en": 'Sentinel Town' } }
        ]
      end

      before do
        allow(response).to receive(:inspect).and_return(
          '#<Faraday::Response env={"Authorization"=>"Bearer api_key"} ' \
          'body={locations:[{source_type:"test",name:{en:"Sentinel Town"}}]}>'
        )
      end

      it 'never logs the response' do
        instance
        expect(log_output).not_to match(/Bearer|Authorization|api_key|Sentinel Town|source_type/)
      end
    end
  end
end

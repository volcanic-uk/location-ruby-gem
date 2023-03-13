# frozen_string_literal: true

require 'json'

RSpec.describe Volcanic::Location::V1::Location do
  let(:conn) { Volcanic::Location::Connection }

  let(:api_path) {}
  let(:source_id) { '1234' }
  let(:pk) { "#{source_type}-#{source_id}" }
  let(:source_type) { 'geonames' }
  let(:params) do
    {
      source_id: source_id,
      source_type: source_type,
      asciiname: 'some-name'
    }
  end
  let(:response) { double 'response' }
  let(:response_body) do
    {
      pk: pk,
      id: 'some-id',
      **params
    }
  end

  subject(:instance) { described_class.new(source_id: source_id, source_type: source_type, **response_body) }

  before do
    allow(response).to receive(:body).and_return(response_body)
    allow_any_instance_of(conn).to receive(:post).with(api_path).and_return(response)
  end

  describe '#create' do
    let(:api_path) { 'api/v1/locations' }
    subject { described_class.create(source_id: source_id, source_type: source_type, **params) }

    context 'when missing source_id' do
      let(:params) { { source_type: source_type } }
      it { expect { described_class.create(**params) }.to raise_error(ArgumentError) }
    end

    context 'when missing source_type' do
      let(:params) { { source_id: source_id } }
      it { expect { described_class.create(**params) }.to raise_error(ArgumentError) }
    end

    it 'creates a new location' do
      expect(subject).to be_an_instance_of(described_class)
      expect(subject.pk).to eq "#{source_type}-#{source_id}"
    end
  end

  context '#create_with_geonames' do
    let(:api_path) { 'api/v1/locations' }

    subject { described_class.create_with_geonames(source_id) }

    it 'creates a new location' do
      expect(subject).to be_an_instance_of(described_class)
      expect(subject.pk).to eq "#{source_type}-#{source_id}"
    end
  end

  describe '#delete' do
    let(:api_path) { "api/v1/locations/#{pk}" }

    before(:each) { allow_any_instance_of(conn).to receive(:delete).with(api_path).and_return(true) }

    it 'deletes the location' do
      expect(subject.delete!).to eq true
    end

    context 'when unpersist' do
      let(:pk) { nil }
      it { expect { subject.delete! }.to raise_error(Volcanic::Location::LocationError) }
    end
  end

  describe '#presisted?' do
    subject { instance.persisted? }
    it { should eq true }

    context 'when unpersist' do
      let(:pk) { nil }
      it { should eq false }
    end
  end

  describe '#save' do
    let(:api_path) { "api/v1/locations/#{pk}" }

    subject { instance.save }
    let(:response_body) do
      {
        pk: 'pk-from-response',
        **params
      }
    end

    it 'updates a location' do
      expect(instance.pk).to eq 'pk-from-response'
    end

    context 'when provide different path' do
      let(:api_path) { '/some-path' }
      subject { instance.save(api_path: api_path) }

      it 'uses the path to send request' do
        expect(instance.pk).to eq 'pk-from-response'
      end
    end
  end
end

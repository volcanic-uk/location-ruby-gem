# frozen_string_literal: true

require 'json'
require 'volcanic/location/exception'

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

  describe '#find' do
    let(:api_path) { "api/v1/locations/#{pk}" }
    let(:pk) { 'test-1234' }
    let(:query_params) { {} }
    before(:each) { allow(response).to receive(:body).and_return(response_body) }
    before(:each) { allow_any_instance_of(conn).to receive(:get).with(api_path, query_params).and_return(response) }

    subject { described_class.find(pk) }

    it 'finds a location' do
      expect(subject).to be_an_instance_of(described_class)
    end

    context 'when with query params' do
      let(:query_params) { { fetch_hierarchy: true } }
      subject { described_class.find(pk, fetch_hierarchy: true) }

      it 'finds a location with query params' do
        expect(subject).to be_an_instance_of(described_class)
      end
    end

    context 'when incorrect primary key provided' do
      let(:pk) { 'test' }
      it 'raises location error' do
        expect { subject }.to raise_error(Volcanic::Location::LocationError)
      end
    end
  end

  describe '#update' do
    let(:api_path) { "api/v1/locations/#{pk}" }
    let(:pk) { 'test-1234' }
    let(:query_params) { { name: { en: 'london' } } }
    let(:response_body) do
      {
        status: 200,
        message: 'Successfully Updated'
      }
    end
    before(:each) { allow(response).to receive(:body).and_return(response_body) }
    before(:each) { allow_any_instance_of(conn).to receive(:post).with(api_path, query_params).and_return(response) }
    let(:params) do
      {
        source_id: source_id,
        source_type: source_type,
        name: { en: 'london' }
      }
    end

    subject { described_class.update(pk, **query_params) }

    it 'updates a location' do
      expect(subject).to be_truthy
    end

    context 'when incorrect primary key provided' do
      let(:pk) { 'test' }
      it 'raises location error' do
        expect { subject }.to raise_error(Volcanic::Location::LocationError)
      end
    end

    context 'when update fails' do
      let(:response_body) do
        {
          status: 404,
          message: 'Location Not Found'
        }
      end
      it 'returns false' do
        expect(subject).to be_falsey
      end
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

  describe '#hierarchy' do
    let(:response_body) do
      {
        hierarchy: [
          { source_id: 1234, source_type: source_type },
          { source_id: 1235, source_type: source_type }
        ]
      }
    end

    it 'generate a collection of Location' do
      expect(subject.hierarchy).to be_a Array
      expect(subject.hierarchy.first).to be_a described_class
    end
  end

  describe '#name' do
    let(:params) do
      {
        name: {
          'en': 'some-name-en',
          'es': 'some-name-es'
        },
        feature_code: feature_code,
        hierarchy: hierarchy
      }
    end
    let(:feature_code) { 'PPL' }
    let(:locale) { :en }
    let(:i18n) { OpenStruct.new(locale: locale) }
    let(:hierarchy) {[
      { source_id: 1234, source_type: source_type,
        name: {
          'en': 'county-en',
          'es': 'county-es'
        },
        feature_code: 'ADM2'},
      { source_id: 1235, source_type: source_type,
        name: {
          'en': 'state-en',
          'es': 'state-es'
        },
        feature_code: 'ADM1' },
        { source_id: 1236, source_type: source_type,
          name: {
            'en': 'country-en',
            'es': 'country-es'
          },
          feature_code: 'PCLI'}
    ]}

    before do
      stub_const('I18n', i18n)
    end

    it 'return en for default' do
      expect(subject.name).to eq 'some-name-en'
    end

    describe 'for other locale' do
      let(:locale) { :es }
      it { expect(subject.name).to eq 'some-name-es' }
    end

    describe 'state enabled' do
      context 'no hierarchy' do
        let(:hierarchy) {}
        it 'returns just name' do 
          expect(subject.name(state: true)).to eq 'some-name-en' 
        end
      end
      context 'with hierarchy' do
        context 'feature code is a town' do
          let(:feature_code) { 'PPL' }
          it 'returns name and state' do 
            expect(subject.name(state: true)).to eq 'some-name-en, state-en' 
          end
        end
        context 'feature code is a county' do
          let(:feature_code) { 'ADM2' }
          it 'returns name and state' do 
            expect(subject.name(state: true)).to eq 'some-name-en, state-en' 
          end
        end
        context 'feature code is a state' do
          let(:feature_code) { 'ADM1' }
          it 'returns just name' do 
            expect(subject.name(state: true)).to eq 'some-name-en' 
          end
        end
        context 'feature code is a country' do
          let(:feature_code) { 'PCLI' }
          it 'returns just name' do 
            expect(subject.name(state: true)).to eq 'some-name-en' 
          end
        end
        context 'for other locale' do
          let(:locale) { :es }
          it { expect(subject.name(state: true)).to eq 'some-name-es, state-es' }
        end
        context 'no state in hierarchy' do
          let(:hierarchy) {[
            { source_id: 1234, source_type: source_type,
              name: {
                'en': 'county-en',
                'es': 'county-es'
              },
              feature_code: 'ADM2'}]}

          it 'returns just name' do 
            expect(subject.name(state: true)).to eq 'some-name-en' 
          end
        end
      end
    end
  end

  describe 'raw_name' do
    let(:response_body) do
      {
        name: {
          'en': 'some-name-en',
          'es': 'some-name-es'
        }
      }
    end

    it { expect(subject.raw_name).to eq response_body[:name] }
  end
end

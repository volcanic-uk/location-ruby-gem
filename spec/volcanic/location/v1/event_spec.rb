# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Volcanic::Location::V1::Event do
  let(:conn) { Volcanic::Location::Connection }
  let(:response) { double('response') }

  before do
    Volcanic::Location.configure do |c|
      c.domain_url = 'http://test.com'
      c.authentication = 'api_key'
    end
  end

  describe '.import_geonames' do
    let(:api_path) { 'api/v1/event/import' }
    let(:params) { { country_code: 'GB', limit: 10, callback_url: 'https://example.com/callback' } }
    let(:response_body) { { status: 202, message: 'Import queued', job_id: 'job-123' } }

    it 'forwards callback_url and returns body with job_id' do
      allow(response).to receive(:body).and_return(response_body)
      expect_any_instance_of(conn).to receive(:post).with(api_path, params).and_return(response)

      result = described_class.import_geonames(country_code: 'GB', limit: 10, callback_url: 'https://example.com/callback')
      expect(result).to eq(response_body)
    end

    it 'omits callback_url from params when nil' do
      allow(response).to receive(:body).and_return(response_body)
      expect_any_instance_of(conn).to receive(:post).with(api_path, { country_code: 'GB', limit: 10 }).and_return(response)

      described_class.import_geonames(country_code: 'GB', limit: 10)
    end
  end

  describe '.hierarchy' do
    let(:api_path) { 'api/v1/event/hierarchy' }
    let(:params) { { country_codes: ['GB'], batch_limit: 40, callback_url: 'https://example.com/callback' } }
    let(:response_body) { { status: 202, message: 'Hierarchy update queued', job_id: 'job-456' } }

    it 'includes callback_url in built params and returns job_id' do
      allow(response).to receive(:body).and_return(response_body)
      expect_any_instance_of(conn).to receive(:post).with(api_path, params).and_return(response)

      result = described_class.hierarchy(country_codes: ['GB'], callback_url: 'https://example.com/callback')
      expect(result).to eq(response_body)
    end
  end
end

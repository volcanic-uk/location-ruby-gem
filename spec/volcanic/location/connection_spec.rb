# frozen_string_literal: true

require 'volcanic/location/version'

RSpec.describe Volcanic::Location::Connection do
  let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
  let(:middleware) {}
  let(:base_url) { Volcanic::Location.configure.domain_url }
  let(:conn) do
    Faraday.new(base_url) do |connection|
      connection.adapter(:test, stubs)
      connection.use middleware
    end
  end

  let(:status) { 200 }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:body) { { foo: 'bar' } }
  let(:response) { [status, headers, body.to_s] }

  subject do
    stubs.get('/foobar') do |env|
      expect(env.url.path).to eq('/foobar')
      response
    end
    conn.get('/foobar')
  end

  describe 'when using User-Agent middleware' do
    let(:middleware) { Volcanic::Location::Middleware::UserAgent }
    it('should contain User-Agent header') do
      expect(subject.env[:request_headers]).to eq('User-Agent' => "Location-ruby-gem v#{Volcanic::Location::VERSION}")
    end
  end

  describe 'when using RequestId middleware' do
    let(:middleware) { Volcanic::Location::Middleware::RequestId }
    it('should contain x-request-id header') do
      expect(subject.env[:request_headers]['x-request-id']).to be_truthy
    end
  end

  describe 'when using Authentication middleware' do
    let(:middleware) { Volcanic::Location::Middleware::Authentication }

    it('should contain Authorization header') do
      expect(subject.env[:request_headers]['Authorization']).to be_truthy
    end

    context 'processing auth key' do
      let(:auth_key) {}
      before { Volcanic::Location.configure.authentication = auth_key }

      context 'when auth_key is a string' do
        let(:auth_key) { '1234' }
        it { expect(subject.env[:request_headers]['Authorization']).to eq 'Bearer 1234' }
      end

      context 'when auth_key is a type of callable' do
        let(:auth_key) { -> { '1234' } }
        it { expect(subject.env[:request_headers]['Authorization']).to eq 'Bearer 1234' }
      end
    end

    context 'when requesting to non-location url' do
      let(:base_url) { 'http://not-location-url' }
      it 'should not content Authorization header' do
        expect(subject.env[:request_headers]['Authorization']).to be_nil
      end
    end
  end

  describe 'when using Exception middleware' do
    let(:middleware) { Volcanic::Location::Middleware::Exception }

    context 'when response status 400' do
      let(:status) { 400 }
      let(:body) { { errorCode: 1001 } }
      it('raises LocationError') { expect { subject }.to raise_error Volcanic::Location::LocationError }
    end

    context 'when response status 403 forbidden' do
      let(:status) { 403 }
      it('raises Forbidden') { expect { subject }.to raise_error Volcanic::Location::Forbidden }
    end

    context 'when response status 404 NotFound' do
      let(:status) { 404 }
      it('raises LocationNotFound') { expect { subject }.to raise_error Volcanic::Location::LocationNotFound }
    end
  end
end

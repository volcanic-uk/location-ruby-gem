# frozen_string_literal: true

require 'volcanic/location/version'
require 'stringio'

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

    context 'when enable custom auth header' do
      before { Volcanic::Location.configure.enable_custom_auth = true }
      it { expect(subject.env[:request_headers]['X-Custom-Auth']).to eq 'true' }
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

  describe 'Faraday logger' do
    let(:test_stubs) { Faraday::Adapter::Test::Stubs.new }
    let(:connection) do
      described_class.new.tap do |instance|
        instance.conn.builder.adapter(:test, test_stubs)
      end
    end
    let(:authorizations) { [] }

    before do
      allow_any_instance_of(Faraday::Retry::Middleware).to receive(:sleep)
      headers = authorizations
      attempts = 0
      test_stubs.get('/api/v1/advanced_search') do |env|
        attempts += 1
        headers << env.request_headers['Authorization']
        raise Faraday::TimeoutError if attempts == 1

        [
          200,
          { 'Content-Type' => 'application/json', 'X-Amzn-Trace-Id' => 'resp-header-value' },
          '{"locations":[]}'
        ]
      end
    end

    def capture_stdout
      original = $stdout
      $stdout = StringIO.new
      yield
      $stdout.string
    ensure
      $stdout = original
    end

    it 'logs the request line and status without headers' do
      logged = capture_stdout do
        connection.conn.get('api/v1/advanced_search')
      end

      expect(authorizations.last).to eq('Bearer api_key')
      expect(logged).to include('GET http://test.com/api/v1/advanced_search')
      expect(logged).to include('Status 200')
      expect(logged).not_to match(/Authorization|Bearer|api_key|User-Agent|resp-header-value/)
    end
  end
end

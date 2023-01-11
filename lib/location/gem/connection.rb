# frozen_string_literal: true

require "faraday"
require "faraday_middleware"
require "forwardable"

Dir[File.join(__dir__, "middleware", "*.rb")].sort.each { |file| require file }

# TODO: need to have spec file
module Location
  module Gem
    # connection
    class Connection
      extend Forwardable

      attr_accessor :conn

      def_delegators "Location::Gem::Configuration".to_sym, :domain_url
      def_delegators :conn, :get, :post, :delete, :put

      def initialize
        @conn = Faraday.new(url: domain_url) do |conn|
          conn.request :json
          conn.request :multipart # to support form data req on s3 singed url
          conn.request :retry, retry_options
          conn.response :json, content_type: /\bjson$/, parser_options: { symbolize_names: true }
          conn.adapter Faraday.default_adapter

          conn.use Faraday::Response::Logger
          # conn.use Location::Gem::Middleware::UserAgent
          # conn.use Location::Gem::Middleware::Authentication
          # conn.use Location::Gem::Middleware::RequestId
          # conn.use Location::Gem::Middleware::Exception
        end
      end

      private

      def retry_options
        {
          max: 3,
          interval: 0.5,
          interval_randomness: 0.5,
          backoff_factor: 2
        }
      end
    end
  end
end

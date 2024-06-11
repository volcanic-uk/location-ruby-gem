# frozen_string_literal: true

# Helper function
module Volcanic
  module Location
    # connection helper
    module LoggerHelper
      attr_writer :logger

      def logger
        @logger ||= defined?(Rails.logger) ? Rails.logger : Logger.new(STDOUT)
      end
    end
  end
end

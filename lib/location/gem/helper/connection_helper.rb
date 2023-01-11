# frozen_string_literal: true

require_relative "../connection"

# Helper function
module Location
  module Gem
    # connection helper
    module ConnectionHelper
      attr_writer :conn

      def conn
        @conn ||= Location::Gem::Connection.new
      end
    end
  end
end

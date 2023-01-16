# frozen_string_literal: true

require_relative "../connection"

# Helper function
module Volcanic
  module Location
    # connection helper
    module ConnectionHelper
      attr_writer :conn

      def conn
        @conn ||= Volcanic::Location::Connection.new
      end
    end
  end
end

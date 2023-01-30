# frozen_string_literal: true

require_relative "location/version"

module Volcanic
  module Location
    class Error < StandardError; end
    # Your code goes here...
  end
end

require_relative "location/config"
require_relative "location/v1"

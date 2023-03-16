# frozen_string_literal: true

require_relative '../volcanic'

module Volcanic
  # forward module declaration
  module Location; end
end

require_relative 'location/config'
require_relative 'location/exception'
require_relative 'location/v1'

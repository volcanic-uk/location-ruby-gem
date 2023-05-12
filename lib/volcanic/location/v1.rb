# frozen_string_literal: true

module Volcanic
  module Location
    # forward module declaration
    module V1; end
  end
end

require_relative 'v1/location'
require_relative 'v1/search'
require_relative 'v1/show'
require_relative 'v1/collection'

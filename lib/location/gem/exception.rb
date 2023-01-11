# frozen_string_literal: true

module Location
  module Gem
    class LocationError < StandardError; end

    class MissingConfiguration < LocationError; end

    class ServerError < LocationError; end
  end
end

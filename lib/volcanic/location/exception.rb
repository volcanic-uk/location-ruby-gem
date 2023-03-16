# frozen_string_literal: true

module Volcanic
  module Location
    class LocationError < StandardError; end

    class MissingConfiguration < LocationError; end

    class ServerError < LocationError; end

    class LocationNotFound < LocationError; end

    class Forbidden < LocationError; end
  end
end

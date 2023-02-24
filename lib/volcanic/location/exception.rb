# frozen_string_literal: true

module Volcanic
  module Location
    class LocationError < StandardError; end

    class MissingConfiguration < LocationError; end

    class ServerError < LocationError; end

    # TODO: find new name for this
    class MiddleError < LocationError; end

    class LocationNotFound < MiddleError; end

    class Forbidden < MiddleError; end

    class S3SignedUrlError < MiddleError; end
  end
end

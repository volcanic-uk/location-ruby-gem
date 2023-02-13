# frozen_string_literal: true

require_relative "middleware"

module Volcanic::Location::Middleware
  # middleware helper
  module Helper
    def domain_url?(uri)
      URI(Volcanic::Location.configure.domain_url).host == uri&.host
    end
  end
end

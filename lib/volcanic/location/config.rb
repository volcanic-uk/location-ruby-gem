# frozen_string_literal: true

# configuration
module Volcanic
  # configuration
  module Location
    def self.configure
      yield Volcanic::Location::Configuration if block_given?
      Volcanic::Location::Configuration
    end

    # configuration class
    class Configuration
      class << self
        attr_accessor :authentication
        attr_writer :domain_url

        def domain_url
          raise_missing_for 'domain' if @domain_url.nil?

          @domain_url
        end

        private

        def raise_missing_for(name)
          raise Volcanic::Location::MissingConfiguration, "#{name} is required to be configured."
        end
      end
    end
  end
end

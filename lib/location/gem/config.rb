# frozen_string_literal: true

# configuration
module Location
  module Gem
    def self.configure
      yield Location::Gem::Configuration if block_given?
      Location::Gem::Configuration
    end

    # configuration class
    class Configuration
      class << self
        attr_writer :domain_url

        def domain_url
          raise_missing_for "domain" if @domain_url.nil?

          @domain_url
        end

        private

        def raise_missing_for(name)
          raise Location::Gem::MissingConfiguration, "#{name} is required to be configured."
        end
      end
    end
  end
end

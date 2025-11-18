# frozen_string_literal: true

require_relative '../helper/connection_helper'
require_relative '../exception'

# api class
class Volcanic::Location::V1::Api
  include Volcanic::Location::ConnectionHelper

  API_PATH = 'api/v1/locations'

  class << self
    def replace(payload:)
      conn = Volcanic::Location::Connection.new
      res = conn.patch("#{API_PATH}/replace", { payload: payload })
      res.body
    end

    def count(country_code:)
      raise Volcanic::Location::LocationError, 'country_code is required' if country_code.nil? || country_code.empty?

      conn = Volcanic::Location::Connection.new
      res = conn.get("#{API_PATH}/count/#{country_code}")
      res.body
    end

    def descendants(id:, per_page: nil, page: nil, to_tree: nil, filter_results: nil)
      raise Volcanic::Location::LocationError, 'id is required' if id.nil? || id.empty?

      conn = Volcanic::Location::Connection.new
      params = { per_page: per_page, page: page, to_tree: to_tree, filter_results: filter_results }.compact
      res = conn.get("#{API_PATH}/descendants/#{id}", params)
      res.body
    end
  end
end

# frozen_string_literal: true

require_relative '../helper/connection_helper'

# event worker class
class Volcanic::Location::V1::Event
  include Volcanic::Location::ConnectionHelper

  API_PATH = 'api/v1/event'

  class << self
    def class_filter
      conn = Volcanic::Location::Connection.new
      res = conn.post("#{API_PATH}/classfilter")
      res.body
    end

    def import_geonames(country_code:, limit: nil)
      conn = Volcanic::Location::Connection.new
      params = { country_code: country_code, limit: limit }.compact
      res = conn.post("#{API_PATH}/import", params)
      res.body
    end

    def translations(country_codes:)
      conn = Volcanic::Location::Connection.new
      res = conn.post("#{API_PATH}/translations", { country_codes: country_codes })
      res.body
    end

    def hierarchy(country_codes:, batch_limit: 40, iteration: nil,
                  ignore_filter_hierarchy: nil, start_key: nil)
      conn = Volcanic::Location::Connection.new
      params = build_hierarchy_params(country_codes, batch_limit, iteration,
                                      ignore_filter_hierarchy, start_key)
      res = conn.post("#{API_PATH}/hierarchy", params)
      res.body
    end

    def sync(ids: nil, country_code: nil, type: nil, iteration: nil)
      conn = Volcanic::Location::Connection.new
      params = { ids: ids, country_code: country_code, type: type, iteration: iteration }.compact
      res = conn.post("#{API_PATH}/sync", params)
      res.body
    end

    def duplicate(country_codes:, batch_limit: 1000, batch_iteration_limit: nil,
                  start_key: nil, update_locations: true)
      conn = Volcanic::Location::Connection.new
      params = build_duplicate_params(country_codes, batch_limit, batch_iteration_limit,
                                      start_key, update_locations)
      res = conn.post("#{API_PATH}/duplicate", params)
      res.body
    end

    def remove_hierarchy(id: nil, replacement_id: nil, batch_limit: nil,
                         batch_iteration_limit: nil)
      conn = Volcanic::Location::Connection.new
      params = build_remove_hierarchy_params(id, replacement_id, batch_limit,
                                             batch_iteration_limit)
      res = conn.post("#{API_PATH}/removeHierarchy", params)
      res.body
    end

    def remove_cache(source_ids: nil, rebuild_source_hierarchy: nil, recursive: nil)
      conn = Volcanic::Location::Connection.new
      params = { source_ids: source_ids, rebuild_source_hierarchy: rebuild_source_hierarchy,
                 recursive: recursive }.compact
      res = conn.post("#{API_PATH}/removeCache", params)
      res.body
    end

    def ur_descendants(ur_id: nil, descendant_ids: nil)
      conn = Volcanic::Location::Connection.new
      params = { UR: ur_id, descendant_ids: descendant_ids }.compact
      res = conn.post("#{API_PATH}/UR_descendants", params)
      res.body
    end

    private

    def build_hierarchy_params(country_codes, batch_limit, iteration,
                               ignore_filter_hierarchy, start_key)
      { country_codes: country_codes, batch_limit: batch_limit, iteration: iteration,
        ignore_filter_hierarchy: ignore_filter_hierarchy, startKey: start_key }.compact
    end

    def build_duplicate_params(country_codes, batch_limit, batch_iteration_limit,
                               start_key, update_locations)
      { country_codes: country_codes, batch_limit: batch_limit,
        batch_iteration_limit: batch_iteration_limit, startKey: start_key,
        update_locations: update_locations }.compact
    end

    def build_remove_hierarchy_params(id, replacement_id, batch_limit,
                                      batch_iteration_limit)
      { id: id, replacement_id: replacement_id, batch_limit: batch_limit,
        batch_iteration_limit: batch_iteration_limit }.compact
    end
  end
end

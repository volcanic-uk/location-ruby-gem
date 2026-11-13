# frozen_string_literal: true

require 'json'
require_relative '../helper/connection_helper'
require_relative '../helper/logger_helper'

# searching class
class Volcanic::Location::V1::Search
  include Volcanic::Location::ConnectionHelper
  include Volcanic::Location::LoggerHelper

  STANDARD_PATH = 'api/v1/locations'
  ADVANCE_PATH = 'api/v1/advanced_search'
  attr_reader('locations', 'pagination')
  attr_accessor :advance

  # Initialiser with filter as param
  # Then call search with the filter
  # by default it uses advance search
  def initialize(advance: true, **filter)
    @advance = advance
    search(filter)
  end

  private

  def search_api
    return ADVANCE_PATH if advance

    STANDARD_PATH
  end

  def search(filter)
    started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    res = conn.get(search_api) do |req|
      req.params = filter
    end

    log_result(res, filter, started_at)

    build_instance(**res.body)
  end

  def log_result(res, filter, started_at)
    duration_ms = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - started_at) * 1000).round
    count = res.body.is_a?(Hash) ? Array(res.body[:locations]).size : 0
    logger.info("Location-ruby-gem Search result: status=#{res.status} count=#{count} " \
                "duration_ms=#{duration_ms} path=#{search_api} params=#{filter.to_json}")
  end

  def build_instance(pagination: {}, locations: [])
    page = destruct_pagination(pagination)

    self.locations =
      Volcanic::Location::V1::Collection.for_locations(locations, **page)
    self.pagination = pagination
  end

  def destruct_pagination(obj)
    {
      page: obj[:page],
      per_page: obj[:per_page],
      total_count: obj[:total_count]
    }
  end

  attr_writer('locations', 'pagination')
end

# frozen_string_literal: true

require_relative '../helper/connection_helper'

# searching class
class Volcanic::Location::V1::Search
  include Volcanic::Location::ConnectionHelper

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
    res = conn.get(search_api) do |req|
      req.params = filter
    end

    build_instance(**res.body)
  end

  def build_instance(pagination: nil, locations: nil)
    page = destruct_pagination(pagination)

    self.locations = 
      Volcanic::Location::V1::Collection.for_locations(locations, **page)
    self.pagination = pagination
  end

  def destruct_pagination(obj)
    {
      page: obj&.page
      per_page: obj&.per_page
      total_count: obj&.total_count
    }
  end

  attr_writer('locations', 'pagination')
end

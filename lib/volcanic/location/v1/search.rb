# frozen_string_literal: true

require_relative "../helper/connection_helper"

# searching class
class Volcanic::Location::V1::Search
  include Volcanic::Location::ConnectionHelper

  API_PATH = "api/v1/locations"
  attr_reader("locations", "pagination")

  # Initialiser with filter as param
  # Then call search with the filter
  def initialize(**filter)
    search(filter)
  end

  private

  def search(filter)
    res = conn.get(API_PATH) do |req|
      req.body = { 'query': filter }
    end

    self.locations = res.body[:locations]
    self.pagination = res.body[:pagination]
    # TODO: create Location objects
  end

  attr_writer("locations", "pagination")
end

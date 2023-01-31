# frozen_string_literal: true

require_relative "../helper/connection_helper"

# searching class
class Volcanic::Location::V1::Search
  include Volcanic::Location::ConnectionHelper

  API_PATH = "api/v1/locations"
  attr_reader("locations")

  # Initialiser with filter as param
  # Then call search with the filter
  def initialize(filter)
    write_attr(filter)
  end

  def search(filter)
    res = conn.get(API_PATH) do |req|
      # req.headers = { "Content-Type" => "multipart/form-data" }
      req.body = { 'query': filter }
    end

    res.body[:locations]
    # TODO: create Location objects
  end

  private

  attr_writer("locations")

  def write_attr(filter)
    self.locations = search(filter)
  end
end

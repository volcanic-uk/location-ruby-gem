# frozen_string_literal: true

require_relative "../helper/connection_helper"

# searching class
class Volcanic::Location::V1::Search
  include Volcanic::Location::ConnectionHelper

  API_PATH = "api/v1/locations"

  # Initialiser with filter as param
  # Then call search with the filter
  def initialize(filter)
    search(filter)
  end

  def search(filter)
    res = conn.get(API_PATH) do |req|
      # req.headers = { "Content-Type" => "multipart/form-data" }
      req.body = { 'query': filter }
    end
    puts("*************")
    puts(res.body[:locations])
    puts("*************")
  end
end
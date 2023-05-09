# frozen_string_literal: true

require_relative '../helper/connection_helper'

# searching class
class Volcanic::Location::V1::Find
  include Volcanic::Location::ConnectionHelper

  PATH = 'api/v1/locations'
  attr_reader('location', 'uuid')

  def initialize(source_type:, source_id:)
    @uuid = "#{source_type}-#{source_id}"
    find
  end

  private

  def find
    res = conn.get("#{PATH}/#{uuid}")

    self.location = Volcanic::Location::V1::Location.new(**res.body[:locations])
  end
end

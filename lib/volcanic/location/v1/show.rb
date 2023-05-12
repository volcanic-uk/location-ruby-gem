# frozen_string_literal: true

require_relative '../helper/connection_helper'

# searching class
class Volcanic::Location::V1::Show
  include Volcanic::Location::ConnectionHelper

  PATH = 'api/v1/locations'
  attr_reader('location', 'id')

  def initialize(source_type:, source_id:)
    @id = "#{source_type}-#{source_id}"
    show
  end

  private

  def show
    res = conn.get("#{PATH}/#{id}")

    self.location = Volcanic::Location::V1::Location.new(**res.body[:locations])
  end
end

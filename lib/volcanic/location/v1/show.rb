# frozen_string_literal: true

require_relative '../helper/connection_helper'
require_relative '../exception.rb'

# searching class
class Volcanic::Location::V1::Show
  include Volcanic::Location::ConnectionHelper

  PATH = 'api/v1/locations'
  attr_reader('id')
  attr_accessor('location')

  def initialize(source_type, source_id)
    raise Volcanic::Location::LocationError unless source_id && source_type

    @id = "#{source_type}-#{source_id}"
    show
  end

  private

  def show
    res = conn.get("#{PATH}/#{id}")

    self.location = Volcanic::Location::V1::Location.new(**res.body)
  end
end

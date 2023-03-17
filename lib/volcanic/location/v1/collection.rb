# frozen_string_literal: true

class Volcanic::Location::V1::Collection < Array

  attr_accessor :page, :page_size

  def initialize(array, page: nil, page_size: nil)
    @page = page
    @page_size = page_size
    super array
  end

  def self.for_locations(collection, **args)
    array = collection.map do |item|
      unless item.is_a?(Hash)
        throw ArgumentError.new('none supported locations data')
      end

      Volcanic::Location::V1::Location.new(**item)
    end

    new(array, **args)
  end
end

# frozen_string_literal: true

module Volcanic::Location::V1
  # collection extends to Array class
  class Collection < Array
    attr_accessor :page, :per_page, :total_count

    def initialize(array, page: nil, per_page: nil, total_count: nil)
      @page = page
      @per_page = per_page
      @total_count = total_count
      super array
    end

    def self.for_locations(collection, **args)
      array = collection.map do |item|
        Volcanic::Location::V1::Location.new(**item)
      end

      new(array, **args)
    end
  end
end

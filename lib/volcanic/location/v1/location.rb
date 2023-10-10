# frozen_string_literal: true

require_relative '../helper/connection_helper'
require_relative '../exception'
require 'json'

# location class
class Volcanic::Location::V1::Location
  extend Volcanic::Location::ConnectionHelper
  include Volcanic::Location::ConnectionHelper

  UPDATABLE_ATTR = %i( name asciiname alternatenames latitude longitude hierarchy_ids
                       coordinate feature_class feature_code country_code source_type source_id
                       admin1 admin2 admin3 admin4 timezone population modification_date
                       parent_id admin1_name descendants_id hide).freeze
  NON_UPDATABLE_ATTR = %i(pk id hierarchy).freeze

  API_PATH = 'api/v1/locations'

  attr_accessor(*UPDATABLE_ATTR)
  attr_reader(*NON_UPDATABLE_ATTR)

  class << self
    def create(source_type:, source_id:, **params)
      new(source_type: source_type, source_id: source_id, **params)
        .tap do |instance|
          instance.save(path: API_PATH)
        end
    end

    def create_with_geonames(source_id)
      new(source_type: 'geonames', source_id: source_id)
        .tap do |instance|
          instance.save(path: API_PATH, fetch_from_source: true)
        end
    end

    def find(id, **params)
      raise Volcanic::Location::LocationError unless id =~ /(\w+)-(\d+)/

      res = conn.get("#{API_PATH}/#{id}", params)

      new(**res.body)
    end

    def update(id, **params)
      raise Volcanic::Location::LocationError unless id =~ /(\w+)-(\d+)/

      res = conn.post("#{API_PATH}/#{id}", params)

      res.body[:status] == 200
    end
  end

  def initialize(source_type:, source_id:, **params)
    write_self(source_type: source_type, source_id: source_id, **params)
  end

  # no API to support this
  # def reload
  #   raise_unpersisted unless persisted?
  #
  #   response = conn.get(persisted_path)
  #   write_self(**response.body)
  #   self
  # end

  # TODO: fix the update path to return the location
  def save(path: persisted_path, **extra_params)
    response = conn.post(path) do |req|
      req.body = fetch_self.merge(extra_params).compact
    end

    response.tap { |res| write_self(**res.body) }
  end

  def delete!
    raise_unpersisted unless persisted?

    conn.delete(persisted_path) && true
  end

  def persisted?
    !(pk.nil? || pk == '')
  end

  #6252001 country A PCLI
  #4361885 State A ADM1 <-------
  #4373554 county A ADM2
  #4366945 town P PPL
  def name(loc: locale, state: false)

    translated_name = @name[:"#{loc}"]
    
    return translated_name unless state && @hierarchy
    
    return translated_name if %w(ADM1 PCLI PCL).include?(@feature_code)

    state = state_name(loc)
    if state
      "#{translated_name}, #{state}" 
    else
      translated_name
    end
  end

  def state_name(val)
    return nil unless @hierarchy

    state = hierarchy.detect do |loc|
      loc.feature_code == 'ADM1'
    end
    if state
      return state.raw_name[:"#{val}"]
    else
      return nil
    end
  end

  # returns the raw value of name
  # eg { en: 'London', es: Londres }
  def raw_name
    @name
  end

  def hierarchy
    return [] unless @hierarchy

    Volcanic::Location::V1::Collection.for_locations(@hierarchy)
  end

  private

  def persisted_path
    "#{API_PATH}/#{pk}"
  end

  def raise_unpersisted
    raise Volcanic::Location::LocationError, 'an unpersisted record, make sure location PK exists!'
  end

  attr_writer(*NON_UPDATABLE_ATTR)

  def write_self(**attrs)
    (UPDATABLE_ATTR + NON_UPDATABLE_ATTR).each do |key|
      send("#{key}=", attrs[key])
    end
    true
  end

  def fetch_self
    Hash[UPDATABLE_ATTR.map do |attr|
      val = if attr == :name
              raw_name
            else
              send(attr)
            end

      [attr, val]
    end]
  end

  def locale
    fetch_i18n || 'en'
  end

  def fetch_i18n
    I18n.locale if defined?(I18n)
  end
end

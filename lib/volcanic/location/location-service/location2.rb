require_relative '../helper/connection_helper'
require_relative 'location_class_method'

Class Location
    
    include Volcanic::Location::ConnectionHelper
    UPDATABLE_ATTR = %i(name geonames_id asciiname alternatenames latitude coordinate feature_class feature_code country_code 
        admin1 admin2 admin3 admin4 timezone population modification_date parent_id admin1_name descendants_id hide)
    NON_UPDATABLE_ATTR = %i(id)
    API_PATH = 'api/v1/locations'

    attr_accessor(*UPDATABLE_ATTR)
    attr_reader(*NON_UPDATABLE_ATTR)

    def initialize(**attrs)
        write_self(attrs)
    end

    def read
        response = conn.get(API_Path)
        write_self(JSON.parse(response.body))
    end

    def save
        conn.post(API_path) do |req|
            req.body = Hash[UPDATABLE_ATTR.map {|attr| [attr, send(attr)] }]
        end
    end

  
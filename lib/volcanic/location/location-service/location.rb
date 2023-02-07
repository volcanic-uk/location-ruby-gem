require_relative '../helper/connection_helper'

Class Location
    
    include Volcanic::Location::ConnectionHelper
    UPDATABLE_ATTR = %i(name asciiname alternatenames latitude coordinate feature_class feature_code country_code 
        admin1 admin2 admin3 admin4 timezone population modification_date parent_id admin1_name descendants_id hide)
    NON_UPDATABLE_ATTR = %i(id geonames_id)
    API_PATH = 'api/v1/locations'

    attr_accessor(*UPDATABLE_ATTR)
    attr_reader(*NON_UPDATABLE_ATTR)

    def initialize(**attrs)
        write_self(attrs)
    end

    def read
        conn.get(API_Path)
    end

    def update
        conn.put("#{API_PATH}")
    end

    def delete()
        conn.delete(API_path, { params })
    end

    private
    def API_path
        "#{API_PATH}/#{id}"
    end

    def params
        params = schema
    end
end
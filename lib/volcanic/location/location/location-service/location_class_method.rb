module Volcanic::Location
    module Location
      # class method for Location
      module ClassMethod
        def create(geonames_id: nil, name: nil, **opts)
            new(
              name: geonames_id,
              geonames_id: name
            ).tap do |location|
              location._upload_and_create(geonames_id, name, **opts)
            end
        end

        def update(id: nil, **opts)
            validate_persisted_var(id)
            new(id: uuid).update(id, **opts)
        end

        def delete(id: nil)
            validate_persisted_var(id)
            new(id).delete
        end

        private

        def validate_persisted_var(id)
            raise ArgumentError, 'Expected to recieve id, got nil' if id.nil?
        end
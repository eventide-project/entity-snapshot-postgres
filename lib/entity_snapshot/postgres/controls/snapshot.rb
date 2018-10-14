module EntitySnapshot
  class Postgres
    module Controls
      module Snapshot
        def self.example(entity_class: nil)
          entity_class ||= subject
          EntitySnapshot::Postgres.build(entity_class)
        end

        def self.subject
          Controls::Entity::Example
        end
      end
    end
  end
end

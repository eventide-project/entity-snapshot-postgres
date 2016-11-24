module EntitySnapshot
  class Postgres
    module Controls
      module Snapshot
        def self.example
          EntitySnapshot::Postgres.build(Controls::Entity::Example)
        end

        def self.subject
          Controls::Entity::Example
        end
      end
    end
  end
end

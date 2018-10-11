module EntitySnapshot
  class Postgres
    module Controls
      module Snapshot
        module ReadOnly
          def self.example
            EntitySnapshot::Postgres::ReadOnly.build(Controls::Entity::Example)
          end
        end
      end
    end
  end
end

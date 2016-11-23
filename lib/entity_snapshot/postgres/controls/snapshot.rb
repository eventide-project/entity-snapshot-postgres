module EntitySnapshot
  module Postgres
    module Controls
      module Snapshot
        def self.example
          Example.build(Controls::Entity::Example)
        end

        def self.subject
          Controls::Entity::Example
        end

        class Example
          include ::EntitySnapshot::Postgres

          category :some_entity
        end
      end
    end
  end
end

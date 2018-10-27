module EntitySnapshot
  class Postgres
    module Controls
      module EntityStore
        def self.example(category: nil, entity_class: nil, projection_class: nil, snapshot_interval: nil)
          reader_class = MessageStore::Postgres::Read
          snapshot_class = EntitySnapshot::Postgres
          snapshot_interval ||= 2
          category ||= 'example'
          ::EntityStore::Controls::EntityStore.example(category: category, entity_class: entity_class, projection_class: projection_class, reader_class: reader_class, snapshot_class: snapshot_class, snapshot_interval: snapshot_interval)
        end

        module Assurance
          def self.example(snapshot_class: nil, snapshot_interval: nil)
            Example.new.tap do |instance|
              instance.snapshot_class = snapshot_class
              instance.snapshot_interval = snapshot_interval
            end
          end

          Example = Struct.new(
            :snapshot_class,
            :snapshot_interval
          )
        end
      end
    end
  end
end

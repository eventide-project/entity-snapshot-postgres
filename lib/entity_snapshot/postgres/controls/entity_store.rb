module EntitySnapshot
  class Postgres
    module Controls
      module EntityStore
        def self.example(category: nil, entity_class: nil, projection_class: nil)
          reader_class = EventSource::Postgres::Read
          snapshot_class = EntitySnapshot::Postgres
          snapshot_interval = 2
          ::EntityStore::Controls::EntityStore.example(category: category, entity_class: entity_class, projection_class: projection_class, reader_class: reader_class, snapshot_class: snapshot_class, snapshot_interval: snapshot_interval)
        end
      end
    end
  end
end

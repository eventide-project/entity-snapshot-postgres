require_relative 'automated_init'

context "Put" do
  entity = Controls::Entity.example

  id = Controls::ID.example
  version = Controls::Version.example
  time = Controls::Time.example

  snapshot = Controls::Snapshot.example

  position = snapshot.put(id, entity, version, time)

  snapshot_stream_name = snapshot.snapshot_stream_name(id, entity)

  read_event = EventSource::Postgres::Get.(snapshot_stream_name, position: position, batch_size: 1).first

  context "Written Entity Snapshot Message" do
    test "Recorded data is the entity data" do
      assert(read_event.data[:entity_data] == entity.attributes.to_h)
    end
  end
end


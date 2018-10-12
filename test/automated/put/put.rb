require_relative '../automated_init'

context "Put" do
  entity = Controls::Entity.example

  id = Controls::ID.example
  version = Controls::Version.example
  time = Controls::Time::Raw.example

  snapshot = Controls::Snapshot.example

  position = snapshot.put(id, entity, version, time)

  snapshot_stream_name = snapshot.snapshot_stream_name(id)

  read_message = MessageStore::Postgres::Get::Last.(snapshot_stream_name)

  context "Written Entity Snapshot Message" do
    test "Recorded data is the entity data" do
      control_data = Controls::Entity::Data.example(entity.some_attribute)

      assert(read_message.data[:entity_data] == control_data)
    end
  end
end


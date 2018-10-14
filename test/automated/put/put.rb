require_relative '../automated_init'

context "Put" do
  entity = Controls::Entity.example

  id = Controls::ID.example
  version = Controls::Version.example
  time = Controls::Time::Raw.example

  snapshot = Controls::Snapshot.example

  position = snapshot.put(id, entity, version, time)

  cateogry = snapshot.category
  snapshot_stream_name = EntitySnapshot::Postgres::StreamName.snapshot_stream_name(id, cateogry)

  context "Written Entity Snapshot Message" do
    read_message = MessageStore::Postgres::Get::Last.(snapshot_stream_name)

    context "Recorded Entity Data" do
      control_data = Controls::Entity::Data.example(entity.some_attribute)

      test "Is the assigned entity data" do
        assert(read_message.data[:entity_data] == control_data)
      end
    end

    context "Recorded Version" do
      test "Is the assigned version" do
        assert(read_message.data[:entity_version] == version)
      end
    end

    context "Recorded Time" do
      control_time = Controls::Time.example

      test "Is the assigned time" do
        assert(read_message.data[:time] == control_time)
      end
    end
  end
end


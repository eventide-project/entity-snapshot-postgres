require_relative '../automated_init'

context "Read Only" do
  context "Put" do
    entity = Controls::Entity.example

    id = Identifier::UUID::Random.get

    version = Controls::Version.example
    time = Controls::Time::Raw.example

    snapshot = Controls::Snapshot::ReadOnly.example

    position = snapshot.put(id, entity, version, time)

    snapshot_stream_name = snapshot.snapshot_stream_name(id)

    context "Entity Snapshot Message" do
      read_message = MessageStore::Postgres::Get::Stream::Last.(snapshot_stream_name)

      test "Not written" do
        assert(read_message.nil?)
      end
    end
  end
end

require_relative '../../automated_init'

context "Transform" do
  context "No Transformer" do
    context "Get" do
      entity = Controls::Entity::NoTransformer.example

      id = Controls::ID.example
      version = Controls::Version.example
      time = Controls::Time::Raw.example


      entity_data = Controls::Entity::Data.example

      event_data = MessageStore::MessageData::Write.new

      event_data.type = 'Recorded'
      event_data.data = entity_data

      position = write.(event_data, stream_name)

EntitySnapshot::Postgres::StreamName.snapshot_stream_name


MessageStore::Postgres::Put.(event_data, stream_name)
















      snapshot = Controls::Snapshot.example(entity_class: entity.class)

      test "Is an error" do
        assert proc { snapshot.put(id, entity, version, time) } do
          raises_error? Transform::Error
        end
      end
    end
  end
end

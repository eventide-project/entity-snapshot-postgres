require_relative '../../automated_init'

context "Read Only" do
  context "Get" do
    entity = Controls::Entity.example

    id = Controls::ID.example
    version = Controls::Version.example
    time = Time.now

    snapshot = Controls::Snapshot::ReadOnly.example

    entity.some_attribute = 'first'
    Controls::Snapshot::Put.(id, entity: entity, version: version, time: time)

    next_version = version + 1
    next_time = Time.now

    entity.some_attribute = 'second'
    Controls::Snapshot::Put.(id, entity: entity, version: next_version, time: next_time)

    recorded_entity, version, time = snapshot.get(id)

    context "Recorded Snapshot" do
      test "Last snapshot is retrieved" do
        assert(entity.some_attribute == 'second')
        assert(version == next_version)
      end

      test "Recorded data is the written data" do
        assert(recorded_entity == entity)
      end
    end
  end
end

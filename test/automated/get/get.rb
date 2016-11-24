require_relative '../automated_init'

context "Get" do
  entity = Controls::Entity.example

  id = Controls::ID.example
  version = Controls::Version.example
  time = Time.now

  snapshot = Controls::Snapshot.example

  entity.some_attribute = 'first'
  snapshot.put(id, entity, version, time)

  next_version = version + 1
  next_time = Time.now

  entity.some_attribute = 'second'
  snapshot.put(id, entity, next_version, next_time)

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

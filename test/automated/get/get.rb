require_relative '../automated_init'

context "Get" do
  entity = Controls::Entity.example

  id = Controls::ID.example
  version = Controls::Version.example
  time = Controls::Time::Raw.example

  snapshot = Controls::Snapshot.example

  entity.some_attribute = 'first'
  snapshot.put(id, entity, version, time)

  next_version = version + 1
  next_time = time + 1

  entity.some_attribute = 'second'
  snapshot.put(id, entity, next_version, next_time)

  recorded_entity, version, time = snapshot.get(id)

  context "Recorded Snapshot" do
    test "Last snapshot is retrieved" do
      assert(entity.some_attribute == 'second')
      assert(version == next_version)
    end

    context "Recorded Entity" do
      test "Is the written entity" do
        assert(recorded_entity == entity)
      end
    end

    context "Recorded Version" do
      test "Is the assigned version" do
        assert(version == next_version)
      end
    end

    context "Recorded Time" do
      test "Is the assigned time" do
        assert(time == next_time)
      end
    end
  end
end

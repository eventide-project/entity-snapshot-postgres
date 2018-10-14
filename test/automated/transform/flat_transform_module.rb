require_relative '../automated_init'

context "Transform" do
  context "Flat Transform Module" do
    entity = Controls::Entity::FlatTransform.example

    id = Controls::ID.example
    version = Controls::Version.example
    time = Controls::Time::Raw.example

    snapshot = Controls::Snapshot.example(entity_class: entity.class)

    snapshot.put(id, entity, version, time)

    recorded_entity, recorded_version, recorded_time = snapshot.get(id)

    context "Recorded Snapshot" do
      context "Recorded Entity" do
        test "Is the written entity" do
          assert(recorded_entity == entity)
        end
      end

      context "Recorded Version" do
        test "Is the assigned version" do
          assert(recorded_version == version)
        end
      end

      context "Recorded Time" do
        test "Is the assigned time" do
          assert(recorded_time == time)
        end
      end
    end
  end
end

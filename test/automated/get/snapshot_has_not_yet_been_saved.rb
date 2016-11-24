require_relative '../automated_init'

context "Get" do
  context "Snapshot Has Not Yet Been Saved" do
    entity = Controls::Entity.example

    id = Identifier::UUID::Controls::Random.example
    version = Controls::Version.example
    time = Time.now

    snapshot = Controls::Snapshot.example

    recorded_entity, version, time = snapshot.get(id)

    context "Recorded Snapshot" do
      test "Is nil" do
        assert(recorded_entity.nil?)
      end
    end
  end
end

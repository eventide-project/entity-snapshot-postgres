require_relative '../../automated_init'

context "Read Only" do
  context "Get" do
    context "Snapshot Has Not Yet Been Saved" do
      entity = Controls::Entity.example

      id = Identifier::UUID::Controls::Random.example

      snapshot = Controls::Snapshot::ReadOnly.example

      recorded_entity, version, time = snapshot.get(id)

      context "Recorded Snapshot" do
        test "Is nil" do
          assert(recorded_entity.nil?)
        end
      end
    end
  end
end

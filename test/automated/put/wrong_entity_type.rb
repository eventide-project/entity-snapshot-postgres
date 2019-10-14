require_relative '../automated_init'

context "Put" do
  context "Wrong Entity Type" do
    entity = Object.new

    id = Controls::ID.example
    version = Controls::Version.example
    time = Controls::Time::Raw.example

    snapshot = Controls::Snapshot.example

    test "Is an error" do
      assert_raises EntitySnapshot::Postgres::Error do
        snapshot.put(id, entity, version, time)
      end
    end
  end
end

require_relative '../automated_init'

context "Assurance" do
  context "Readonly" do
    snapshot_class = EntitySnapshot::Postgres::ReadOnly

    context "Store Has the Snapshot Class" do
      store = Controls::EntityStore::Assurance.example(
        snapshot_class: snapshot_class
      )

      test "Is not an error" do
        refute proc { snapshot_class.assure(store) } do
          raises_error?
        end
      end
    end

    context "Store Is Missing the Snapshot Class" do
      store = Controls::EntityStore::Assurance.example

      test "Is an error" do
        assert proc { snapshot_class.assure(store) } do
          raises_error? EntityCache::Store::External::Error
        end
      end
    end

    context "Store Is Missing the Interval" do
      store = Controls::EntityStore::Assurance.example(
        snapshot_class: snapshot_class
      )

      test "Is Not an error" do
        refute proc { snapshot_class.assure(store) } do
          raises_error? EntityCache::Store::External::Error
        end
      end
    end

    context "Store Has the Interval" do
      store = Controls::EntityStore::Assurance.example(
        snapshot_interval: 11
      )

      test "Is an error" do
        assert proc { snapshot_class.assure(store) } do
          raises_error? EntityCache::Store::External::Error
        end
      end
    end
  end
end

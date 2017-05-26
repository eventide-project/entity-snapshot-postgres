require_relative 'automated_init'

context "Snapshot Stream Name" do
  entity = Controls::Entity.example
  id = Controls::ID.example

  snapshot = Controls::Snapshot.example

  snapshot_stream_name = snapshot.snapshot_stream_name(id)

  context "First Part" do
    context "Category" do
      category = Messaging::StreamName.get_category(snapshot_stream_name)
      parts = category.split(':')

      test "Has two parts separated by a colon" do
        assert(parts.count == 2)
      end

      context "First Part" do
        entity_class_name = entity.class.name.split('::').last
        entity_cateogry = Casing::Camel.(entity_class_name)

        test "Is the entity class name" do
          assert(parts.first == entity_cateogry)
        end
      end

      context "Second Part" do
        test "Is the snapshot type" do
          assert(parts.last == 'snapshot')
        end
      end
    end
  end

  context "Second Part" do
    stream_id = Messaging::StreamName.get_id(snapshot_stream_name)

    test "Is the ID" do
      assert(snapshot_stream_name.end_with? "-#{id}")
    end
  end
end


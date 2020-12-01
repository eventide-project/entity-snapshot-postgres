require_relative '../automated_init'

context "Snapshot Stream Name" do
  context "Subject Has A Specifier" do
    entity = Controls::Entity.example
    id = Controls::ID.example

    specifier = Controls::Specifier.example

    snapshot = Controls::Snapshot.example(specifier: specifier)

    snapshot_stream_name = snapshot.snapshot_stream_name(id)

    category = Messaging::StreamName.get_category(snapshot_stream_name)

    control_category = Controls::Category::Specifier.example(specifier)

    test "Category includes the specifier after the entity basename" do
      comment category.inspect
      detail "Control Category: #{control_category.inspect}"

      assert(category == control_category)
    end
  end
end

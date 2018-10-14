require_relative '../../automated_init'

context "Transform" do
  context "No Transformer" do
    context "Put" do
      entity = Controls::Entity::NoTransformer.example

      id = Controls::ID.example
      version = Controls::Version.example
      time = Controls::Time::Raw.example

      snapshot = Controls::Snapshot.example(entity_class: entity.class)

      test "Is an error" do
        assert proc { snapshot.put(id, entity, version, time) } do
          raises_error? Transform::Error
        end
      end
    end
  end
end

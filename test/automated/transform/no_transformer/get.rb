require_relative '../../automated_init'

context "Transform" do
  context "No Transformer" do
    context "Get" do
      entity = Controls::Entity.example

      id = Controls::ID.example
      version = Controls::Version.example
      time = Controls::Time::Raw.example

      snapshot = Controls::Snapshot.example(entity_class: entity.class)
      snapshot.put(id, entity, version, time)

      no_transformer_entity = Controls::Entity::NoTransformer.example
      no_transformer_snapshot = Controls::Snapshot.example(entity_class: no_transformer_entity.class)

      test "Is an error" do
        assert proc { no_transformer_snapshot.get(id) } do
          raises_error? Transform::Error
        end
      end
    end
  end
end

module EntitySnapshot
  class Recorded
    include Messaging::Message

    attribute :entity_data
    attribute :entity_version
  end
end

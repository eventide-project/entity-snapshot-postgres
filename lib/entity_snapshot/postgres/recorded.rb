module EntitySnapshot
  class Recorded
    include Messaging::Message

    attribute :entity_data
    attribute :entity_version

    module Serializer
      def self.raw_data(instance)
        instance.to_h
      end

      def self.instance(raw_data)
        Message.build raw_data
      end
    end
  end
end

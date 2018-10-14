module EntitySnapshot
  class Postgres
    module StreamName
      extend self

      def snapshot_stream_name(id, category=nil)
        category ||= self.category
        Messaging::StreamName.stream_name(id, category, type: 'snapshot')
      end

      def self.category(entity_class)
        *, entity_class_name = entity_class.name.split('::')
        Casing::Camel.(entity_class_name)
      end
    end
  end
end

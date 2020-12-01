module EntitySnapshot
  class Postgres
    module StreamName
      extend self

      def snapshot_stream_name(id, category=nil)
        category ||= self.category

        Messaging::StreamName.stream_name(id, category, type: 'snapshot')
      end

      def self.category(entity_class, specifier=nil)
        *, entity_class_name = entity_class.name.split('::')

        entity_class_name = Casing::Camel.(entity_class_name)

        if specifier.nil?
          entity_class_name
        else
          "#{entity_class_name}#{specifier}"
        end
      end
    end
  end
end

module EntitySnapshot
  class Postgres
    module StreamName
      extend self

      def self.included(cls)
        cls.class_exec do
          include Messaging::StreamName
        end
      end

      def snapshot_stream_name(id, category=nil)
        stream_name(id, category, type: 'snapshot')
      end
    end
  end
end

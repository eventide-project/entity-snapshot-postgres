module EntitySnapshot
  class Postgres
    class ReadOnly
      include Log::Dependency
      include EntityCache::Store::External

      include StreamName

      dependency :read, MessageStore::Postgres::Get::Last

      attr_accessor :session

      alias_method :entity_class, :subject

      def category
        *, entity_class_name = entity_class.name.split('::')

        Casing::Camel.(entity_class_name)
      end

      def configure(session: nil)
        MessageStore::Postgres::Session.configure(self, session: session)
        MessageStore::Postgres::Get::Last.configure(self, session: self.session, attr_name: :read)
      end

      def get(id)
        stream_name = snapshot_stream_name(id)

        logger.trace(tags: [:snapshot, :cache, :get]) { "Reading snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name})" }

        event_data = read.(stream_name)

        if event_data.nil?
          logger.debug(tags: [:snapshot, :cache, :get]) { "No snapshot record (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name})" }
          return
        end

        entity_data = event_data.data[:entity_data]

        entity = Transform::Read.instance(entity_data, entity_class)

        version = event_data.data[:entity_version]
        time = event_data.time

        logger.debug(tags: [:snapshot, :cache, :get]) { "Read snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name}, Version: #{version.inspect}, Time: #{time.utc.iso8601(3)})" }

        return entity, version, time
      end

      def put(*)
      end
    end
  end
end

module EntitySnapshot
  class Postgres
    module Get
      def self.prepended(cls)
        cls.class_exec do
          include StreamName
        end
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
    end
  end
end

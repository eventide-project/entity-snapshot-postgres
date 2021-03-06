module EntitySnapshot
  class Postgres
    module Get
      def self.prepended(cls)
        cls.class_exec do
          include StreamName
        end
      end

      def entity_class
        subject.entity_class
      end

      def get(id)
        stream_name = snapshot_stream_name(id)

        logger.trace(tags: [:cache, :get]) { "Reading snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name}, Specifier: #{subject.specifier || '(none)'})" }

        event_data = read.(stream_name)

        if event_data.nil?
          logger.debug(tags: [:cache, :get, :missg]) { "No snapshot record (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name}, Specifier: #{subject.specifier || '(none)'})" }
          return
        end

        entity_data = event_data.data[:entity_data]

        entity = Transform::Read.instance(entity_data, entity_class)

        version = event_data.data[:entity_version]

        time = event_data.data[:time]

        # Backward compatibility for messages not written with
        # a timestamp in the message data
        # Sat Oct 13, Scott Bellware
        if time.nil?
          time ||= event_data.time
        else
          time = Time.parse(time)
        end

        logger.debug(tags: [:cache, :get, :hit]) { "Read snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name}, Specifier: #{subject.specifier || '(none)'}, Version: #{version.inspect}, Time: #{time.utc.iso8601(3)})" }

        return entity, version, time
      end
    end
  end
end

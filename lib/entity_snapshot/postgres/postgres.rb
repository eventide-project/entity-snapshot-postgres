module EntitySnapshot
  module Postgres
    def self.included(cls)
      cls.class_exec do
        prepend Configure
        prepend Get
        prepend Put

        include Log::Dependency

        include Messaging::StreamName
        include EntityCache::Storage::Persistent

        # dependency :writer, Messaging::Postgres::Write
        dependency :writer, EventSource::Postgres::Write

        alias_method :entity_class, :subject
      end
    end

    def snapshot_stream_name(id)
      category_name = self.category
      category_name = "#{category_name}:snapshot"

      stream_name id, category_name
    end

    module Configure
      def configure(session: nil)
        # Messaging::Postgres::Write.configure(self, session: session)
        EventSource::Postgres::Write.configure(self, session: session)
      end
    end

    module Put
      def put(id, entity, version, time)
        stream_name = snapshot_stream_name(id)

        logger.trace "Writing snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity.class.name}, Version: #{version.inspect}, Time: #{time})"

        entity_data = Transform::Write.raw_data(entity)

        event_data = EventSource::EventData::Write.new

        data = {
          entity_data: entity_data,
          entity_version: version
        }

        event_data.type = 'Recorded'
        event_data.data = data

        position = writer.(event_data, stream_name)

        # recorded = Recorded.new

        # recorded.entity_data = entity_data
        # recorded.entity_version = version

        # position = writer.(recorded, stream_name)

        logger.debug "Wrote snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity.class.name}, Version: #{version.inspect}, Time: #{time})"

        position
      end
    end

    module Get
      # def get(id)
      #   stream_name = snapshot_stream_name id

      #   logger.trace "Reading snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name})"

      #   reader = EventStore::Client::HTTP::Reader.build stream_name, slice_size: 1, direction: :backward

      #   event = nil
      #   reader.each do |_event|
      #     event = _event
      #     break
      #   end

      #   if event.nil?
      #     logger.debug "Snapshot could not be read (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name})"
      #     return
      #   end

      #   message = Serialize::Read.instance event.data, Message
      #   entity = message.entity entity_class

      #   version, time = message.version, message.time

      #   logger.debug "Read snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name}, Version: #{version.inspect}, Time: #{time})"

      #   return entity, version, time
      # end
    end
  end
end

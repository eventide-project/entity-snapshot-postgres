module EntitySnapshot
  class Postgres
    include Log::Dependency
    include EntityCache::Storage::Persistent

    dependency :writer, EventSource::Postgres::Write

    alias_method :entity_class, :subject

    def snapshot_stream_name(id)
      entity_class_name = entity_class.name.split('::').last
      entity_cateogry = Casing::Camel.(entity_class_name)

      Messaging::StreamName.stream_name(id, "#{entity_cateogry}:snapshot")
    end

    def configure(session: nil)
      EventSource::Postgres::Write.configure(self, session: session)
    end

    def put(id, entity, version, time)
      unless entity.is_a? subject
        raise Error, "Persistent storage for #{subject} cannot store #{entity}"
      end

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

      logger.debug "Wrote snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity.class.name}, Version: #{version.inspect}, Time: #{time})"

      position
    end

    def get(id)
      stream_name = snapshot_stream_name id

      logger.trace "Reading snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name})"

      reader = EventStore::Client::HTTP::Reader.build stream_name, slice_size: 1, direction: :backward

      event = nil
      reader.each do |_event|
        event = _event
        break
      end

      if event.nil?
        logger.debug "Snapshot could not be read (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name})"
        return
      end

      message = Serialize::Read.instance event.data, Message
      entity = message.entity entity_class

      version, time = message.version, message.time

      logger.debug "Read snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name}, Version: #{version.inspect}, Time: #{time})"

      return entity, version, time
    end
  end
end

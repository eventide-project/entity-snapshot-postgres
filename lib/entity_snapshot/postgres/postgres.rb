module EntitySnapshot
  class Postgres
    include Log::Dependency
    include EntityCache::Storage::Persistent

    dependency :writer, EventSource::Postgres::Put

    alias_method :entity_class, :subject

    def snapshot_stream_name(id)
      entity_class_name = entity_class.name.split('::').last
      entity_cateogry = Casing::Camel.(entity_class_name)

      Messaging::StreamName.stream_name(id, "#{entity_cateogry}:snapshot")
    end

    def configure(session: nil)
      EventSource::Postgres::Put.configure(self, session: session, attr_name: :writer)
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
      stream_name = snapshot_stream_name(id)

      logger.trace "Reading snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name})"

      event_data = EventSource::Postgres::Get.(stream_name, batch_size: 1, precedence: :desc).first

      if event_data.nil?
        logger.debug "No snapshot could not be read (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name})"
        return
      end

      entity = entity_class.build(event_data.data[:entity_data])
      version = event_data.data[:entity_version]
      time = event_data.time

      logger.debug "Read snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity_class.name}, Version: #{version.inspect}, Time: #{time})"

      return entity, version, time
    end
  end
end

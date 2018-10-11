module EntitySnapshot
  class Postgres
    include Log::Dependency
    include EntityCache::Store::External

    dependency :write, MessageStore::Postgres::Put
    dependency :read, MessageStore::Postgres::Get::Last

    attr_accessor :session

    alias_method :entity_class, :subject

    def snapshot_stream_name(id)
      entity_class_name = entity_class.name.split('::').last
      entity_category = Casing::Camel.(entity_class_name)

      Messaging::StreamName.stream_name(id, entity_category, type: 'snapshot')
    end

    def configure(session: nil)
      MessageStore::Postgres::Session.configure(self, session: session)
      MessageStore::Postgres::Put.configure(self, session: self.session, attr_name: :write)
      MessageStore::Postgres::Get::Last.configure(self, session: self.session, attr_name: :read)
    end

    def put(id, entity, version, time)
      unless entity.is_a? subject
        error_msg = "Persistent storage for #{subject} cannot store #{entity}"
        logger.error() { error_msg }
        raise Error, error_msg
      end

      stream_name = snapshot_stream_name(id)

      logger.trace(tags: [:snapshot, :cache, :put]) { "Writing snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity.class.name}, Version: #{version.inspect}, Time: #{time.utc.iso8601(3)})" }

      entity_data = Transform::Write.raw_data(entity)

      event_data = MessageStore::MessageData::Write.new

      data = {
        entity_data: entity_data,
        entity_version: version
      }

      event_data.type = 'Recorded'
      event_data.data = data

      position = write.(event_data, stream_name)

      logger.debug(tags: [:snapshot, :cache, :put]) { "Wrote snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity.class.name}, Version: #{version.inspect}, Time: #{time.utc.iso8601(3)})" }

      position
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

    Error = Class.new(RuntimeError)
  end
end

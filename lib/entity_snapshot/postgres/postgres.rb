module EntitySnapshot
  class Postgres
    include Log::Dependency

    prepend Get
    include EntityCache::Store::External

    include StreamName

    dependency :write, MessageStore::Postgres::Put
    dependency :read, MessageStore::Postgres::Get::Last

    attr_accessor :session

    alias_method :entity_class, :subject

    def category
      StreamName.category(subject)
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

      logger.trace(tags: [:cache, :put]) { "Writing snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity.class.name}, Version: #{version.inspect}, Time: #{time.utc.iso8601(3)})" }

      entity_data = Transform::Write.raw_data(entity)

      event_data = MessageStore::MessageData::Write.new

      iso8601_time = Clock::UTC.iso8601(time)

      data = {
        entity_data: entity_data,
        entity_version: version,
        time: iso8601_time
      }

      event_data.type = 'Recorded'
      event_data.data = data

      position = write.(event_data, stream_name)

      logger.debug(tags: [:cache, :put]) { "Wrote snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity.class.name}, Version: #{version.inspect}, Time: #{time.utc.iso8601(3)})" }

      position
    end

    def self.assure(store)
      if [store.snapshot_class, store.snapshot_interval].include?(nil)
        raise EntityCache::Store::External::Error
      end
    end

    Error = Class.new(RuntimeError)
  end
end

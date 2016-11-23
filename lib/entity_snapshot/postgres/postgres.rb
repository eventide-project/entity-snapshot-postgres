module EntitySnapshot
  module Postgres
    def self.included(cls)
      cls.class_exec do
        include Messaging::StreamName
        include EntityCache::Storage::Persistent

        dependency :writer, Messaging::Postgres::Write

        alias_method :entity_class, :subject
      end
    end

    def snapshot_stream_name(id)
      category_name = self.category_name
      category_name = "#{category_name}:snapshot"

      stream_name id, category_name
    end

    def configure
      Messaging::Postgres::Write.configure self
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

    def put(id, entity, version, time)
      stream_name = snapshot_stream_name id

      logger.trace "Writing snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity.class.name}, Version: #{version.inspect}, Time: #{time})"

      data = Serialize::Write.raw_data entity

      message = Message.new
      message.id = id
      message.data = data
      message.version = version
      message.time = time

      writer.write message, stream_name

      logger.debug "Wrote snapshot (Stream: #{stream_name.inspect}, Entity Class: #{entity.class.name}, Version: #{version.inspect}, Time: #{time})"
    end
  end
end

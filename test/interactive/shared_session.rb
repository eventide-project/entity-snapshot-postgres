ENV['LOG_TAGS'] ||= 'session,_untagged'
ENV['LOG_LEVEL'] ||= 'debug'

require_relative 'interactive_init'


projection_class = EntityStore::Controls::Projection::Example
reader_class = MessageStore::Postgres::Read
snapshot_class = EntitySnapshot::Postgres
snapshot_interval = 1
category = 'example'
entity_class = EntityStore::Controls::Entity::Example

store_class = Class.new do
  include ::EntityStore

  category category
  entity entity_class
  projection projection_class
  reader reader_class
  snapshot snapshot_class, interval: snapshot_interval
end

session = MessageStore::Postgres::Session.build
store = store_class.build(session: session)

store.get(SecureRandom.hex)
store.get(SecureRandom.hex)
store.get(SecureRandom.hex)

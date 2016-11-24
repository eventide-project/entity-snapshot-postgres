require_relative 'automated_init'

context "Entity Store" do
  batch = Controls::Batch.example(count: 3)
  pp batch

  stream_name = Controls::Write.batch(category: 'example', count: 3)
  pp stream_name

  store = Controls::EntityStore.example
  pp store

  id = Messaging::StreamName.get_id(stream_name)
  pp id

  store.get(id)
end

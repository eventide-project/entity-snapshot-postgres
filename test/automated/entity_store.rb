require_relative 'automated_init'

context "Entity Store" do
  batch = Controls::Batch.example
  pp batch

  stream_name = Controls::Write.batch(category: 'example')
  pp stream_name

  store = Controls::EntityStore.example
  pp store
end

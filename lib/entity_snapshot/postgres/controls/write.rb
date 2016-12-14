module EntitySnapshot
  class Postgres
    module Controls
      module Write
        def self.batch(stream_name: nil, category: nil, count: nil, starting_number: nil)
          stream_name ||= Controls::StreamName.example(category: category)

          write = ::Messaging::Postgres::Write.build

          batch = Batch.example(count: count, starting_number: starting_number)

          write.(batch, stream_name)

          stream_name
        end
      end
    end
  end
end

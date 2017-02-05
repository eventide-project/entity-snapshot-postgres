require_relative 'automated_init'

context "Entity Store" do
  snapshot_interval = 2

  store = Controls::EntityStore.example(snapshot_interval: snapshot_interval)

  comment "Write 2, First snapshot"

  total = 0
  count = 2

  stream_name = Controls::Write.batch(category: 'example', count: count)
  id = Messaging::Postgres::StreamName.get_id(stream_name)

  snapshot_stream_name = "example:snapshot-#{id}"

  total = total + count

  context "Projecting #{count} Events [Written: #{total}, Interval: #{snapshot_interval}, Mod: #{total % snapshot_interval}]" do
    entity = store.get(id)

    snapshot_position = 0

    context "Writes first snapshot" do
      snapshot_event = EventSource::Postgres::Get.(snapshot_stream_name, position: snapshot_position, batch_size: 1).first

      entity_data = snapshot_event.data[:entity_data]
      sum = entity_data[:sum]
      entity_version = snapshot_event.data[:entity_version]

      context "Entity Data" do
        test "Sum accumulates to #{sum}" do
          assert(sum == 12)
        end

        test "Entity version recorded is #{entity_version}" do
          assert(entity_version == 1)
        end
      end
    end
  end


  comment "Write 1, No snapshot"

  count = 1
  total = total + count
  starting_number = total

  Controls::Write.batch(stream_name: stream_name, count: count, starting_number: starting_number)

  context "Projecting #{count} Events [Written: #{total}, Interval: #{snapshot_interval}, Mod: #{total % snapshot_interval}]" do
    entity = store.get(id)

    snapshot_position = 1

    context "Second Snapshot" do
      snapshot_event = EventSource::Postgres::Get.(snapshot_stream_name, position: snapshot_position, batch_size: 1).first

      test "Is not written" do
        assert(snapshot_event.nil?)
      end
    end
  end


  comment "Write 1, Second snapshot"

  count = 1
  total = total + count
  starting_number = total

  Controls::Write.batch(stream_name: stream_name, count: count, starting_number: starting_number)

  context "Projecting #{count} Events [Written: #{total}, Interval: #{snapshot_interval}, Mod: #{total % snapshot_interval}]" do
    entity = store.get(id)

    snapshot_position = 1

    context "Writes second snapshot" do
      snapshot_event = EventSource::Postgres::Get.(snapshot_stream_name, position: snapshot_position, batch_size: 1).first

      entity_data = snapshot_event.data[:entity_data]
      sum = entity_data[:sum]
      entity_version = snapshot_event.data[:entity_version]

      context "Entity Data" do
        test "Sum accumulates to #{sum}" do
          assert(sum == 1234)
        end

        test "Entity version recorded is #{entity_version}" do
          assert(entity_version == 3)
        end
      end
    end
  end


  comment "Write 1, No snapshot"

  count = 1
  total = total + count
  starting_number = total

  Controls::Write.batch(stream_name: stream_name, count: count, starting_number: starting_number)

  context "Projecting #{count} Events [Written: #{total}, Interval: #{snapshot_interval}, Mod: #{total % snapshot_interval}]" do
    entity = store.get(id)

    snapshot_position = 2

    context "Third Snapshot" do
      snapshot_event = EventSource::Postgres::Get.(snapshot_stream_name, position: snapshot_position, batch_size: 1).first

      test "Is not written" do
        assert(snapshot_event.nil?)
      end
    end
  end


  comment "Write 3, Third snapshot"

  count = 3
  starting_number = total + 1
  total = total + count

  Controls::Write.batch(stream_name: stream_name, count: count, starting_number: starting_number)

  context "Projecting #{count} Events [Written: #{total}, Interval: #{snapshot_interval}, Mod: #{total % snapshot_interval}]" do
    entity = store.get(id)

    snapshot_position = 2

    context "Writes third snapshot" do
      snapshot_event = EventSource::Postgres::Get.(snapshot_stream_name, position: snapshot_position, batch_size: 1).first

      entity_data = snapshot_event.data[:entity_data]
      sum = entity_data[:sum]
      entity_version = snapshot_event.data[:entity_version]

      context "Entity Data" do
        test "Sum accumulates to #{sum}" do
          assert(sum == 12345678)
        end

        test "Entity version recorded is #{entity_version}" do
          assert(entity_version == 7)
        end
      end
    end
  end
end

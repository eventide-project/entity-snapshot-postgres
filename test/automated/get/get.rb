# require_relative '../automated_init'

# context "Put" do
#   entity = Controls::Entity.example

#   id = Controls::ID.example
#   version = Controls::Version.example
#   time = Controls::Time.example

#   snapshot = Controls::Snapshot.example

#   position = snapshot.put(id, entity, version, time)

#   recorded_entity, version, time = snapshot.get(id)

#   context "Read Snapshotted Entity" do
#     test "Recorded data is the written data" do
#       assert(recorded_entity == entity)
#     end
#   end
# end


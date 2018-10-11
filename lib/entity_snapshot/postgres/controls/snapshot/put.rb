module EntitySnapshot
  class Postgres
    module Controls
      module Snapshot
        module Put
          def self.call(id=nil, entity: nil, version: nil, time: nil)
            id ||= ID.example
            entity ||= Entity.example
            version ||= Version.example
            time ||= Time::Raw.example

            snapshot = Snapshot.example

            snapshot.put(id, entity, version, time)
          end
        end
      end
    end
  end
end

module EntitySnapshot
  module Postgres
    module Controls
      module Snapshot
        class Example
          include ::EntitySnapshot::Postgres

          category :some_entity
        end
      end
    end
  end
end

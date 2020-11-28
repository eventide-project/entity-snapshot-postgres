module EntitySnapshot
  class Postgres
    module Controls
      module Snapshot
        def self.example
          EntitySnapshot::Postgres.build(subject)
        end

        def self.subject
          Subject.example
        end
      end
    end
  end
end

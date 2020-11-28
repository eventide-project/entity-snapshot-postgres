module EntitySnapshot
  class Postgres
    module Controls
      module Snapshot
        def self.example(specifier: nil)
          subject = Subject.example(specifier: specifier)

          EntitySnapshot::Postgres.build(subject)
        end
      end
    end
  end
end

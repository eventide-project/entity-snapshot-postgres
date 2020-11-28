module EntitySnapshot
  class Postgres
    module Controls
      module Snapshot
        module ReadOnly
          def self.example
            EntitySnapshot::Postgres::ReadOnly.build(subject)
          end

          def self.subject
            Subject.example
          end
        end
      end
    end
  end
end

module EntitySnapshot
  class Postgres
    module Controls
      module Category
        def self.example
          'example:snapshot'
        end

        module Specifier
          def self.example(specifier=nil)
            specifier ||= Specifier.example

            "example#{specifier}:snapshot"
          end
        end
      end
    end
  end
end

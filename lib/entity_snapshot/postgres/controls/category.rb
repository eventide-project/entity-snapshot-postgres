module EntitySnapshot
  class Postgres
    module Controls
      module Category
        def self.example
          "#{Type.example}:snapshot"
        end

        module Type
          def self.example
            'example'
          end
        end
        EntityPart = Type

        module Specifier
          def self.example(specifier=nil)
            specifier ||= Controls::Specifier.example

            "#{Type.example}#{specifier}:snapshot"
          end
        end
      end
    end
  end
end

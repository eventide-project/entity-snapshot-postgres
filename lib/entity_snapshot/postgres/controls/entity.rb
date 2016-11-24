module EntitySnapshot
  class Postgres
    module Controls
      # Entity = EntityStore::Controls::Entity

      module Entity
        def self.example
          Example.build(Data.example)
        end

        class Example
          include Schema::DataStructure

          attribute :some_attribute

          module Transformer
            def self.raw_data(instance)
              instance.to_h
            end

            def self.instance(raw_data)
              Example.build(raw_data)
            end
          end
        end

        module Data
          def self.example
            {
              some_attribute: EventSource::Controls::RandomValue.example
            }
          end
        end
      end
    end
  end
end

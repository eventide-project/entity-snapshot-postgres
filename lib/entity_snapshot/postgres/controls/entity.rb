module EntitySnapshot
  class Postgres
    module Controls
      module Entity
        def self.example
          Example.build(data)
        end

        def self.data
          {
            :some_attribute => RandomValue.example,
            :some_time => Time::Raw.example
          }
        end

        class Example
          include Schema::DataStructure

          attribute :some_attribute, String
          attribute :some_time, ::Time

          module Transformer
            def self.raw_data(instance)
              {
                :some_attribute => instance.some_attribute,
                :some_time => Clock.iso8601(instance.some_time)
              }
            end

            def self.instance(raw_data)
              Example.build({
                :some_attribute => raw_data[:some_attribute],
                :some_time => Clock.parse(raw_data[:some_time])
              })
            end
          end
        end

        module Data
          def self.example(some_attribute=nil)
            some_attribute ||= RandomValue.example

            {
              some_attribute: some_attribute,
              some_time: Time::ISO8601.example
            }
          end
        end

        module NoTransformer
          def self.example
            Example.build(
              some_attribute: RandomValue.example
            )
          end

          class Example
            include Schema::DataStructure

            attribute :some_attribute, String
          end
        end

        module FlatTransform
          def self.example
            Example.build(
              some_attribute: RandomValue.example
            )
          end

          class Example
            include Schema::DataStructure
            include ::EntitySnapshot::Postgres::FlatTransform

            attribute :some_attribute, String
          end
        end
      end
    end
  end
end

module EntitySnapshot
  class Postgres
    module Controls
      module Message
        def self.example(number: nil)
          number ||= 1
          Example.build number: number
        end

        def self.first
          Example.build :number => 1
        end

        def self.second
          Example.build :number => 11
        end

        class Example
          include Messaging::Message

          attribute :number
        end
      end
    end
  end
end

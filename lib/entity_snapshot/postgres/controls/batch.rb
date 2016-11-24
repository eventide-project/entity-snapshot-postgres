module EntitySnapshot
  class Postgres
    module Controls
      module Batch
        def self.example(count: nil)
          count ||= 2

          batch = []
          count.times do |i|
            number = ('1' * (i + 1)).to_i
            batch << Controls::Message.example(number: number)
          end

          batch
        end
      end
    end
  end
end

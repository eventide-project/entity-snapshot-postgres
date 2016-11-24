module EntitySnapshot
  class Postgres
    module Controls
      module Batch
        def self.example(count: nil, starting_number: nil)
          count ||= 2
          starting_number ||= 1

          batch = []
          count.times do |i|
            number = ('1' * (i + starting_number)).to_i
            batch << Controls::Message.example(number: number)
          end

          batch
        end
      end
    end
  end
end

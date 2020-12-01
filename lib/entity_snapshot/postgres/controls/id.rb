module EntitySnapshot
  class Postgres
    module Controls
      module ID
        def self.example
          Identifier::UUID::Controls::Random.example
        end
      end
    end
  end
end

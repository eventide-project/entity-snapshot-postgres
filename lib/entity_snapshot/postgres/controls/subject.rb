module EntitySnapshot
  class Postgres
    module Controls
      module Subject
        def self.example(entity_class: nil, specifier: nil, random: nil)
          entity_class ||= self.entity_class
          specifier ||= Specifier.example

          ::EntityCache::Controls::Subject.example(entity_class: entity_class, specifier: specifier, random: random)
        end

        def self.entity_class
          Entity::Example
        end

        def self.specifier
          Specifier.example
        end
      end
    end
  end
end

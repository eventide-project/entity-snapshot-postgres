module EntitySnapshot
  class Postgres
    module FlatTransform
      def self.included(cls)
        constant_name = 'Transform'
        unless cls.const_defined?(constant_name, false)
          cls.const_set(constant_name, transform_module)
        end
      end

      def self.extended(obj)
        cls = obj.class
        included(cls)
      end

      def self.transform_module
        Module.new do
          def self.instance(raw_data, cls)
            cls.build(raw_data)
          end

          def self.raw_data(instance)
            instance.to_h
          end
        end
      end
    end
  end
end

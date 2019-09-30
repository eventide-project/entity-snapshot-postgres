module EntitySnapshot
  class Postgres
    class ReadOnly
      include Log::Dependency

      prepend Get
      include EntityCache::Store::External

      dependency :read, MessageStore::Postgres::Get::Stream::Last

      attr_accessor :session

      alias_method :entity_class, :subject

      def category
        *, entity_class_name = entity_class.name.split('::')

        Casing::Camel.(entity_class_name)
      end

      def configure(session: nil)
        MessageStore::Postgres::Session.configure(self, session: session)
        MessageStore::Postgres::Get::Stream::Last.configure(self, session: self.session, attr_name: :read)
      end

      def put(*)
      end

      def self.assure(store)
        if store.snapshot_class.nil?
          raise EntityCache::Store::External::Error
        end
      end
    end
  end
end

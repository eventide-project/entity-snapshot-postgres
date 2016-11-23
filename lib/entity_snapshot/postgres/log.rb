module EntitySnapshot
  module Postgres
    class Log < ::Log
      def tag!(tags)
        tags << :entity_snapshot_postgres
        tags << :library
        tags << :verbose
      end
    end
  end
end

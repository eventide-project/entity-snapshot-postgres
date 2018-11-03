module EntitySnapshot
  class Postgres
    class Log < ::Log
      def tag!(tags)
        tags << :snapshot
      end
    end
  end
end

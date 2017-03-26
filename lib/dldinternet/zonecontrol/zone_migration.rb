module Clouddns
  class ZoneMigration
    module Change
      class None
        def to_s length=30
          record.format(:prefix => print_prefix, :namelength => length)
        end
      end
    end
  end
end

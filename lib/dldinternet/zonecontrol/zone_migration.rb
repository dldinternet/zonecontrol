module DLDInternet
  module ZoneControl
    class ZoneMigration
      module Change
        class None < Struct.new(:record)
          def perform! fog_zone
          end
          def print_prefix; ' '; end
          def to_s length=30
            record.format(:prefix => print_prefix, :namelength => length)
          end
        end
        class Create < None
          def perform!(fog_zone)
            fog_zone.records.create(record)
          end
          def print_prefix; '+'; end
        end
        class Remove < None
          def perform!(fog_zone)
            # fog_zone.records.all!.select do |fog_record|
            #   matches = record.equal?(fog_record)
            #   unless matches.empty?
            #     matches.each do |idx|
            #       fog_record.destroy
            #     end
            #   end
            # end
            fog_zone.records.delete(record.id)
          end
          def print_prefix; '-'; end
        end
      end

      def initialize zone, fog_zone
        @zone = zone
        @fog_zone = fog_zone
        @changes = nil
      end

      def changes
        return @changes if @changes
        @changes = []
        # fog_records = Hash[@fog_zone.records.map {|r| [[fog_record_name(r), r.type], r] } ]
        fog_records = {}
        @fog_zone.records.map { |r|
          value = @fog_zone.ttl
          fog_records[[r.name, r.type]] ||= []
          fog_records[[r.name, r.type]] << r
        }
        # fog_records = @fog_zone.records
        zone_records = []
        @zone.records.each do |type, list|
          list.each do |rec|
            record = rec.dup
            record[:type] ||= type.to_s.upcase
            record[:priority] ||= record[:pri] if record[:pri]
            record[:data] ||= record[:host] if record[:host]
            record[:data] ||= record[:value] if record[:value]
            record[:data] ||= record[:text] if record[:text]
            record[:name] = '@' if record[:name].downcase.eql?(@zone.origin.downcase)
            record[:name].gsub!(%r{\.#{@zone.origin.downcase.gsub(/\./, '\.')}}, '')
            record[:zone] = @fog_zone
            zone_records << @fog_zone.records.new(record)
          end
        end
        zone_records.each do |rec|
          record = ZoneRecord.create(rec.to_h) #.with_indifferent_access
          needle = [record[:name], record[:type]]
          fog_record = fog_records[needle] # unless fog_record.size > 0
          if fog_record && fog_record.size > 0
            matches = record.equal?(fog_record)
            # Nothing matched ... delete all and add replacement for this needle
            if matches.empty?
              fog_record.each do |rr|
                @changes << Change::Remove.new(ZoneRecord.create(rr))
              end
              @changes << Change::Create.new(record)
            else
              # Do nothing about this record
              # # Delete all the matched records
              matches.sort.reverse.each do |idx|
                @changes << Change::None.new(ZoneRecord.create(fog_record[idx]))
                fog_record.delete_at(idx)
              end
            end
          else
            @changes << Change::Create.new(record)
          end
        end

        fog_records.each do |_, fog_record|
          fog_record.each do |rr|
            @changes << Change::Remove.new(ZoneRecord.create(rr))
          end
        end
        @changes
      end

      def perform!
        changes.each do |change|
          change.perform! @fog_zone
        end
      end

      def completed?
        changes.all? do |change|
          change.class == Change::None
        end
      end
    end
  end
end

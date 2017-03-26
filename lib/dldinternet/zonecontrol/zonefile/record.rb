
module DLDInternet
  module ZoneControl
    module ZoneFile
      class Record

        def self.manufacture(type, name, value, options = {})
          DLDInternet::ZoneControl::ZoneFile.const_get("Record#{type}").new(type, name, value, options)
        rescue
          self.new(type, name, value, options)
        end

        require "dldinternet/zonecontrol/zonefile/record/mx"
        require "dldinternet/zonecontrol/zonefile/record/soa"
        require "dldinternet/zonecontrol/zonefile/record/srv"

        def format(options={})
          options[:namelength] ||= 20
          options[:prefix] ||= ''

          format_it(options)
        end

        def print_it(options={})
          value.each_with_index do |val, i|
            printf("%-#{options[:namelength] ||18}s %5i IN %-5s %s\n", name, ttl, type, val)
          end
        end

        def format_it(options)
          output = []

          value.each_with_index do |value, i|
            if i.zero?
              args = [options[:prefix], type, ttl, name, value]
            else
              args = [options[:prefix], '', '', '', value]
            end
            output << "%s%5s %5s %#{options[:namelength]}s %s" % args
          end

          output.join("\n")
        end
      end
    end
  end
end


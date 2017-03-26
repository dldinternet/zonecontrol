module DLDInternet
  module ZoneControl
    module ZoneFile
      class RecordSRV < Record
        def format_it(options={})
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


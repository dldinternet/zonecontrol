module DLDInternet
  module ZoneControl
    module ZoneFile
      class RecordSOA < Record

        def email;   attributes[:email];  end
        def serial;  attributes[:serial];  end
        def retryt;  attributes[:retry];   end
        def expire;  attributes[:expire];  end
        def refresh; attributes[:refresh]; end

        def print_it(options={})
          value.each_with_index do |val, i|
            # dldec.com. 3600 IN SOA burst.dldinternet.com. hostmaster.delionsden.com. 2014060701 3600 300 3600 3600
            printf("%-#{options[:namelength] ||18}s %5i IN #{type} #{val} #{email} #{serial} %5i %5i %5i %5i \n", name, ttl, refresh, retryt, expire, ttl)
          end
        end

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


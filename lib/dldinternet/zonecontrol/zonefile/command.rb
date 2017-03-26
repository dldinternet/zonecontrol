require 'dldinternet/zonecontrol'

module DLDInternet
  module ZoneControl
    module ZoneFile
      class Command < DLDInternet::ZoneControl::Thor::Command

        desc 'generate FILES', "Print the zonefiles described by FILES"
        def generate(*files)
          return help('generate', true) unless files.size > 0
          command_pre(files)
          each_zone files do |zone|
            DLDInternet::ZoneControl::Actions::ZoneFile::Generate.run(zone, self)
          end
          0
        end

        desc 'parse FILES', "Parse the zonefiles described by FILES"
        def parse(*files)
          return help('parse', true) unless files.size > 0
          command_pre(files)
          each_zonefile files do |zonefile|
            DLDInternet::ZoneControl::Actions::ZoneFile::Parse.run(zonefile, self)
          end
          0
        end

      end
    end
  end
end

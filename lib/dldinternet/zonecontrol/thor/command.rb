require "dldinternet/thor/command"
require "dldinternet/zonecontrol"

module DLDInternet
  module ZoneControl
    module Thor
      class Command < DLDInternet::Thor::Command

        protected

        def each_zone(files)
          files = files_list(files)
          files.each do |file|
            dsl = DLDInternet::ZoneControl::ZoneFile::DSL.parse_file(file)
            dsl.zones.each do |zone|
              yield zone, dsl.fog_options
            end
          end
        end

        def each_zonefile(files)
          files = files_list(files)
          files.each do |file|
            dsl = DLDInternet::ZoneControl::ZoneFile::DSL.parse_zonefile(file)
            dsl.zones.each do |zone|
              yield zone, dsl.fog_options
            end
          end
        end

        def files_list(files)
          list = files.map do |filename|
            if File.exist?(filename)
              filename
            else
              Dir.glob(filename)
            end
          end
          list.flatten
        end
      end
    end
  end
end


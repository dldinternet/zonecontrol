require 'dldinternet/zonecontrol/actions/generic_action'
require 'dldinternet/zonecontrol/actions/migrate'
require 'dldinternet/zonecontrol/actions/zonefile'
require 'dldinternet/zonecontrol/actions/print'

module DLDInternet
  module ZoneControl
    module Actions
      def self.by_name name
        case name.downcase
        when 'print' then Print
        when 'migrate' then Migrate
        when 'zonefile' then Zonefile
        else
          raise "Unknown action: #{name}"
        end
      end
    end
  end
end



require 'dldinternet/zonecontrol/actions'

module DLDInternet
  module ZoneControl
    module Actions
      module ZoneFile
        class Parse < GenericAction
          def run
            write(@zone.dsl, '.zone')
          end
        end
      end
    end
  end
end

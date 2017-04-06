require 'dldinternet/zonecontrol/actions'

module DLDInternet
  module ZoneControl
    module Actions
      module ZoneFile
        class Parse < GenericAction
          def run
            write(@domain.dsl, '.zone')
          end
        end
      end
    end
  end
end

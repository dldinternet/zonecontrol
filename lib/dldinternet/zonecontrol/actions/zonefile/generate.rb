require 'dldinternet/zonecontrol/actions'

module DLDInternet
  module ZoneControl
    module Actions
      module ZoneFile
        class Generate < GenericAction
          def run
            write(@domain.output)
          end
        end

      end
    end
  end
end

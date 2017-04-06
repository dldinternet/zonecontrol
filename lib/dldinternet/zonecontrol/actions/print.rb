
module DLDInternet
  module ZoneControl
    module Actions
      class Print < GenericAction

        def run()
          puts @domain.print(command.options.to_hash.merge(@options))
        end

      end
    end
  end
end

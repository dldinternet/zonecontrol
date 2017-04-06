require 'thor'

module DLDInternet
  module ZoneControl
    module Actions
      class GenericAction < ::Thor::Shell::Basic

        def initialize(zone, command, options = {})
          @domain  = zone
          @command = command
          @options = options
          @logger = command.logger
          super()
        end
        def self.run(zone, command, options = {})
          new(zone, command, options).run
        end

        def options; @options; end
        def command; @command; end

        def write(output, ext='')
          if (destination = command.options[:destination])
            if File.directory?(destination)
              if @domain.filename
                path = File.join(destination, @domain.filename+ext)
                command.logger.info "Write to #{path}"
                File.write(path, output)
              else
                command.logger.warn "Zone filename unknown"
              end
            else
              command.logger.error "Destination directory invalid!"
            end
          else
            puts output
          end
        end
      end
    end
  end
end

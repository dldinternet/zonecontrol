
module DLDInternet
  module ZoneControl
    module Actions
      class Push < GenericAction
        def run
          require 'fog'

          domain = @domain.name.gsub(%r{\.$}, '')
          @fog = Fog::DNS.new(Hashie::Mash.new(@options[:fog]))
          require "dldinternet/zonecontrol/fog"

          @fog_zone = @fog.zones.find { |z|
            z.domain == domain
          }

          @logger.note "Migrating '#{domain}'"

          unless @fog_zone
            @fog_zone = create_zone!
          end

          # required to pick up nameservers and records
          @fog_zone.reload

          print_nameservers

          @migration = ZoneMigration.new(@domain, @fog_zone)

          print_changes

          # no changes required
          return if @migration.completed?

          require_confirmation!

          @migration.perform!

          puts "Done"
        end

        private

        def create_zone!
          puts
          puts "Zone '#{@domain.name}' does not exist. Creating..."
          require_confirmation!
          fog_zone = @fog.zones.create(:domain => @domain.name)
          puts "Zone '#{@domain.name}' created."
        end

        def print_nameservers
          puts
          puts "Nameservers:"
          @fog_zone.nameservers.each do |nameserver|
            puts "  #{nameserver}"
          end
        end

        def print_changes
          # s = @migration.changes.last.to_s
          namelength = @migration.changes.map do |change|
            change.record.name.length
          end.max

          all_changes = @migration.changes
          real_changes = all_changes.select { |change| change.class != DLDInternet::ZoneControl::ZoneMigration::Change::None }

          puts
          puts "Records: #{all_changes.size}"
          puts "Changes: #{real_changes.size}"

          all_changes.each do |change|
            puts change.to_s(namelength)
          end
        end

        def require_confirmation!
          unless @options[:force] || yes?('Continue?')
            exit 1
          end
        end
      end
    end
  end
end


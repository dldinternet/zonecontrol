require 'dldinternet/zonecontrol'
require 'dldinternet/zonecontrol/dsl'

module DLDInternet
  module ZoneControl
    class Main < DLDInternet::Thor::Command
      class_option :verbose,      type: :boolean
      class_option :debug,        type: :boolean
      class_option :trace,        type: :boolean
      class_option :log_level,    type: :string, banner: 'Log level ([:trace, :debug, :info, :step, :warn, :error, :fatal, :todo])'
      class_option :provider,     type: :string, aliases: '-p'
      class_option :format,       type: :string, default: :none, aliases: [ '--output']
      class_option :config,       type: :string, default: '~/.config/doctl/config.yaml'

      desc 'push FILES', "Update live DNS servers with changes from FILES"
      method_option :force, :type => :boolean, :aliases => "-f"
      def push *files
        opts = {fog: {}}
        opts[:fog][:provider] = options[:provider] if options[:provider]
        opts[:force] = !!options[:force]
        each_zone files do |zone, fog_options|
          puts;puts
          o = opts.merge({fog: opts.fetch(:fog, {}).merge(fog_options)})
          Clouddns::Actions::Migrate.run(zone, o)
        end
        0
      end

      desc 'version', "Print the current version"
      map "-v" => :version
      map "--version" => :version
      def version
        # puts DLDInternet::CloudDNS::VERSION
        command_pre
        command_out "#{self.class.namespace} version #{::DLDInternet::ZoneControl::VERSION}"
        0
      end

      desc 'print FILES', "Print the DNS records described by FILES"
      def print *files
        each_zone files do |zone|
          puts;puts
          Clouddns::Actions::Print.run(zone)
        end
        0
      end

      desc 'zonefile FILES', "Print the zonefile described by FILES"
      def zonefile *files
        each_zone files do |zone|
          puts;puts
          Clouddns::Actions::Zonefile.run(zone)
        end
        0
      end

      private

      def each_zone(files)
        files = files_list(files)
        files.each do |file|
          dsl = Clouddns::DSL.parse_file(file)
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


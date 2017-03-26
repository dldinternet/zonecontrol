require 'dldinternet/zonecontrol'

module DLDInternet
  module ZoneControl
    class Main < DLDInternet::ZoneControl::Thor::Command
      class_option :verbose,      type: :boolean
      class_option :debug,        type: :boolean
      class_option :trace,        type: :boolean
      class_option :log_level,    type: :string, banner: 'Log level ([:trace, :debug, :info, :step, :warn, :error, :fatal, :todo])'
      class_option :provider,     type: :string, aliases: '-p'
      class_option :credentials,  type: :string, aliases: '-C'
      class_option :format,       type: :string, default: :none, aliases: [ '--output']
      class_option :config,       type: :string, default: '~/.config/zonecontrol/config.yaml'
      class_option :destination,  type: :string, aliases: [ '--target']#, default: ''

      desc 'push FILES', "Update live DNS servers with changes from FILES"
      method_option :force, :type => :boolean, :aliases => "-f"
      def push *files
        command_pre(files)
        opts = {fog: options[:fog].to_hash || {}}
        opts[:fog][:provider] = options[:provider] if options[:provider]
        opts[:force] = !!options[:force]
        each_zone files do |zone, fog_options|
          o = opts.merge({fog: opts.fetch(:fog, {}).merge(fog_options)})
          DLDInternet::ZoneControl::Actions::Push.run(zone, self, o)
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
      method_option :namelength,       type: :numeric, aliases: [ '--namewidth']
      def print *files
        command_pre(files)
        each_zone files do |zone|
          DLDInternet::ZoneControl::Actions::Print.run(zone, self)
        end
        0
      end

      desc 'zonefile SUBCOMMAND', "Manipulate zonefiles"
      subcommand 'zonefile', ::DLDInternet::ZoneControl::ZoneFile::Command

    end
  end
end


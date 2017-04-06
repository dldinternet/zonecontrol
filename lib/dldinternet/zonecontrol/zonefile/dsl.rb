require 'zonefile'

module DLDInternet
  module ZoneControl
    module ZoneFile
      class DSL
        attr_reader :zones
        attr_reader :fog_options

        def initialize(filename=nil)
          @zones       = []
          @domain      = nil
          @defaults    = {}
          @fog_options = {}
          @filename    = filename.gsub(%r{\.zone$}, '')
        end

        def self.parse_string(string, filename=nil)
          dsl = DSL.new(filename)
          dsl.instance_eval string
          dsl
        end

        def self.parse_file(filename)
          parse_string(File.read(filename), filename.split('/').last)
        end

        def self.parse_zonestring(string, filename=nil)
          dsl = DSL.new(filename)
          dsl.zonestring_eval(string, filename)
          dsl
        end

        def self.parse_zonefile filename
          # zf = Zonefile.from_file(filename)
          parse_zonestring(File.read(filename), filename.split('/').last)
        end

        def zonestring_eval(string, filename=nil)
          zf = ::Zonefile.new(string)
          zf.filename = filename
          zf.ttl = @defaults[:ttl] || zf.soa[:ttl]
          zf.origin = zf.soa[:origin]
          @zones << zf
        end

        protected

        record_types = %w{A AAAA CNAME MX NS PTR SOA SPF SRV TXT}
        record_types.each do |type|
          define_method type do |*args|
            add_record type, *args
          end
          define_method type.downcase do |*args|
            add_record type, *args
          end
        end

        def provider name, options={}
          @fog_options = options.merge({:provider => name})
        end

        def parse_domain(name)
          if name =~ /\A(.*?\..*?)\.?\z/
            "#{$1}."
          else
            raise "Invalid domain: '#{name}'"
          end
        end

        def add_record(type, *args)
          options = args[-1].is_a?(Hash) ? args.pop : {}
          name,value = args
          name = @domain.name if name.eql?('@')
          name = parse_domain(name)
          options = @defaults.merge(options)
          options[:primary] ||= value if type.downcase.to_sym == :soa
          options[:name] ||= name
          options[:host] ||= value

          @domain.add_record(type, options)
        end

        def zone(name=nil)
          raise "zones cannot be nested" if @domain && name
          if name
            @domain = ::Zonefile.new('', @filename, parse_domain(name))
            @zones << @domain
            yield
            @domain = nil
          else
            @domain.name
          end
        end

        def defaults options={}
          if block_given?
            old = @defaults
            @defaults = @defaults.merge(options)
            yield
            @defaults = old
          else
            # raise "defaults must either take a block or be before any zone declarations" unless @zones.empty?
            @defaults = @defaults.merge(options)
          end
        end
      end
    end

  end
end


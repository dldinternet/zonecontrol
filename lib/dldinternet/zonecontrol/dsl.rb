module Clouddns
  class DSL

    def self.dsl
      @dsl ||= DSL.new
    end

    def self.parse_string string
      dsl.instance_eval string
      dsl
    end

    # def self.parse_file filename
    #   #parse_string open(filename).read
    #   begin
    #     add_path, source_file = File.split(File.expand_path(filename))
    #     dsl.instance_eval '$:.unshift(add_path) unless $:.include?(add_path)'
    #     dsl.instance_eval 'ap $:'
    #     dsl.instance_eval "require '#{File.expand_path(filename)}'"
    #   rescue Exception => e
    #     abort "Cannot parse #{source_file}\n\n" + e.message + "\n\n" + e.backtrace.ai
    #   end
    # end

    protected

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


class ZoneRecord < HashWithIndifferentAccess

  def self.type_data(args)
    type, data = args.flatten
    if data.nil?
      data = type
      type = data[:type]
    end
    if !data.is_a?(Hash) && data.respond_to?(:to_h)
      rec = data
      data = data.to_h
    end
    data = data.with_indifferent_access unless data.is_a?(HashWithIndifferentAccess)
    type ||= data[:type]
    data[:type] ||= type
    data[:pri] ||= data[:priority] if data[:priority]
    data[:value] ||= data[:data] if data[:data]
    data[:host] ||= data[:data] if data[:data]
    if rec
      #rec.merge_attributes(data)
      #data = rec
      data[:record] = rec
    end
    return data, type
  end

  def self.create(*args)
    data, type = type_data(args)
    klasa = self.class.name.split('::')
    klasa[-1] = "Zone#{type rescue ''}Record"
    klass = klasa.inject(Object) { |mod, class_name|
      mod.const_get(class_name)
    }
    klass.new(type, data)
  rescue => e
    $stderr.write "#{__FILE__}::#{__LINE__} - #{e.class.name} #{e.message}\n"
    raise e # ZoneRecord.new(type, data)
  end

  def initialize(*args)
    data, type = ZoneRecord.type_data(args)
    # unless data.is_a?(HashWithIndifferentAccess)
    #   data[:fog_record] = data
    # end
    me = super(data)
    me[:type] = type
    me
  end

  def format(options = {})
    s = sprintf("%s%-#{options[:namelength] ||18}s %5s %s %-5s %s",
            options[:prefix] || '',
            self[:name], ttlof, classof, self[:type],
            self[:host])
    s
  end

  def ttlof
    soattl = zone.ttl rescue -1
    self[:ttl] == soattl ? '' : self[:ttl].to_s
  end

  def classof
    self[:class].nil? || self[:class].eql?('IN') ? '' : self[:class]
  end

  def method_missing(m, *args)
    mname = m.to_s.sub("=","")
    return super unless keys.include?(mname)

    if m.to_s[-1].chr == '=' then
      self[mname.intern] = args.first
      self[mname.intern]
    else
      self[m]
    end
  end

  def fog_record_name record
    record.name.gsub('\052', '*')
  end

  def equal?(fog_records)
    # AWS replaces * with \052
    eq = []
    # fog_records = [fog_records] unless fog_records.is_a?(Array)
    Array(fog_records).map.with_index.each do |fog_record, idx|
      fog_ttl = fog_record.ttl.to_i rescue nil # zone.ttl
      value = self[:value].respond_to?(:sort) ? self[:value].sort : self[:value].downcase.gsub(/\.$/, '')
      fog_value = fog_record.value.respond_to?(:sort) ? fog_record.value.sort : fog_record.value.downcase.gsub(/\.$/, '')
      if self[:name].downcase.eql?(fog_record.name.downcase) &&
          self[:type].to_s.upcase.eql?(fog_record.type.to_s.upcase) &&
          value.eql?(fog_value) &&
          (fog_ttl.nil? || self[:ttl].nil? || self[:ttl].to_i == fog_ttl)
        eq << idx
      end
    end
    eq
  end
end

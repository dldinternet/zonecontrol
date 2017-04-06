class ZoneNAPTRRecord < ZoneRecord

  def format(options = {})
    # "  NAPTR  '#{naptr[:name]}', nil, order: '#{naptr[:order]}', preference: '#{naptr[:preference]}',
    # flags: '#{naptr[:flags]}', service: '#{naptr[:service]}', regexp: '#{naptr[:regexp]}', replacement: '#{naptr[:replacement]}'#{ttlclass(naptr)}\n"
    sprintf(%(%s%-#{options[:namelength] ||18}s %5i %s %-5s %s %s "%s" "%s" "%s" %s),
            options[:prefix] || '',
            self[:name], ttlof, classof, 'NAPTR',
            self[:order],
            self[:preference],
            self[:flags],
            self[:service],
            self[:regexp],
            self[:replacement])
  end

end

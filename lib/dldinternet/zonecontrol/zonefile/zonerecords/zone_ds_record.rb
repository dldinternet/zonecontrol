class ZoneDSRecord < ZoneRecord

  def format(options = {})
    # "  DS     '#{self[:name]}', nil, key_tag: '#{self[:key_tag]}', algorithm: '#{self[:algorithm]}', digest_type: '#{self[:digest_type]}', digest: '#{self[:digest]}'#{ttlclass(self)}"
    sprintf("%s%-#{options[:namelength] ||18}s %5i %s %-5s %s %s %s ( %s )",
            options[:prefix] || '',
            self[:name], ttlof, classof, 'DS',
            self[:key_tag],
            self[:algorithm],
            self[:digest_type],
            self[:digest])
  end

end

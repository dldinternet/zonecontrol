class ZoneNSEC3PARAMRecord < ZoneRecord

  def format(options = {})
    # "  NSEC3PARAM '#{nsec[:name]}', nil, algorithm: '#{nsec[:algorithm]}', flags: '#{nsec[:flags]}',
    # iterations: '#{nsec3[:iterations]}', salt: '#{nsec3[:salt]}'#{ttlclass(nsec)}\n"
    sprintf("%s%-#{options[:namelength] ||18}s %5i %s %-5s %s %s %s %s ",
            options[:prefix] || '',
            self[:name], ttlof, classof, 'NSEC3PARAM',
            self[:algorithm],
            self[:flags],
            self[:iterations],
            self[:salt])
  end

end

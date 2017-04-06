class ZoneNSEC3Record < ZoneRecord

  def format(options = {})
    # "  NSEC3  '#{nsec[:name]}', nil, algorithm: '#{nsec[:algorithm]}', flags: '#{nsec[:flags]}',
    # iterations: '#{nsec3[:iterations]}', salt: '#{nsec3[:salt]}', next: '#{nsec[:next]}', types: '#{nsec[:types]}'#{ttlclass(nsec)}\n"
    sprintf("%s%-#{options[:namelength] ||18}s %5i %s %-5s %s %s %s %s %s ( %s )",
            options[:prefix] || '',
            self[:name], ttlof, classof, 'NSEC3',
            self[:algorithm],
            self[:flags],
            self[:iterations],
            self[:salt],
            self[:next],
            self[:types])
  end

end

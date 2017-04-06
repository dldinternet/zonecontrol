class ZoneNSECRecord < ZoneRecord

  def format(options = {})
    # "  NSEC   '#{nsec[:name]}', nil, next: '#{nsec[:next]}', types: '#{nsec[:types]}'#{ttlclass(nsec)}\n"
    sprintf("%s%-#{options[:namelength] ||18}s %5i %s %-5s %s ( %s )",
            options[:prefix] || '',
            self[:name], ttlof, classof, 'RRSIG',
            self[:next],
            self[:types])
  end

end

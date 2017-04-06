class ZonePTRRecord < ZoneRecord

  def format(options = {})
    # "  PTR    '#{self[:name]}', '#{self[:host]}'#{ttlclass(self)}"
    sprintf("%s%-#{options[:namelength] ||18}s %5i %s %-5s %s",
            options[:prefix] || '',
            self[:name], ttlof, classof, 'PTR',
            self[:host])
  end

end

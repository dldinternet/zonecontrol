class ZoneMXRecord < ZoneRecord

  def format(options = {})
    s = sprintf("%s%-#{options[:namelength] ||18}s %5s %s %-5s %-5s %s",
            options[:prefix] || '',
            self[:name], ttlof, classof, 'MX',
            self[:pri],
            self[:host])
    s
  end

end

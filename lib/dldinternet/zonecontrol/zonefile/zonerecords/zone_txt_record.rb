class ZoneTXTRecord < ZoneRecord

  def format(options = {})
    sprintf("%s%-#{options[:namelength] ||18}s %5s %s %-5s %s",
            options[:prefix] || '',
            self[:name], ttlof, classof, 'TXT',
            self[:text])
  end

end

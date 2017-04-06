class ZoneSRVRecord < ZoneRecord

  def format(options = {})
    # "  SRV    '#{self[:name]}', '#{self[:host]}', pri: #{self[:pri]}, weight: #{self[:weight]}, port: #{self[:port]}#{ttlclass(self)}"
    sprintf("%s%-#{options[:namelength] ||18}s %5i %s %-5s %s %s %s %s\n",
            options[:prefix] || '',
            self[:name], ttlof, classof, 'SRV',
            self[:priority],
            self[:weight],
            self[:port],
            self[:host])
  end

end

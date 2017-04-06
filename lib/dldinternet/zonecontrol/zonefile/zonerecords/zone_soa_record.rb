class ZoneSOARecord < ZoneRecord

  def format(options = {})
    sprintf("%s%-#{options[:namelength] ||18}s %5i %s %s %s %s %s %5i %5i %5i %5i",
            options[:prefix] || '',
            self[:origin],
            self[:ttl],
            classof,
            self[:type] || 'SOA',
            self[:primary],
            self[:email],
            self[:serial],
            self[:refresh],
            self[:retry],
            self[:expire],
            self[:minimumTTL])
  end

end

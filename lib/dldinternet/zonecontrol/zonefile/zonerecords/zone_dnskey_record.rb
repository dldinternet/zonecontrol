class ZoneDNSKEYRecord < ZoneRecord

  def format(options = {})
    # "  DNSKEY '#{dnskey[:name]}', nil, flag: '#{dnskey[:flag]}', protocol: '#{dnskey[:protocol]}', algorithm: '#{dnskey[:algorithm]}', public_key: '#{dnskey[:public_key]}'#{ttlclass(dnskey)}\n"
    sprintf("%s%-#{options[:namelength] ||18}s %5i %s %-5s %s %s %s ( %s )",
            options[:prefix] || '',
            self[:name], ttlof, classof, 'DNSKEY',
            self[:flag],
            self[:protocol],
            self[:algorithm],
            self[:public_key])
  end

end

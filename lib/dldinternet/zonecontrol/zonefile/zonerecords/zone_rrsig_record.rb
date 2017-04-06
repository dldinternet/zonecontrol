class ZoneRRSIGRecord < ZoneRecord

  def format(options = {})
    # "  RRSIG  '#{rrsig[:name]}', nil, type_covered: '#{rrsig[:type_covered]}', algorithm: '#{rrsig[:algorithm]}', labels: '#{rrsig[:labels]}', original_ttl: #{rrsig[:original_ttl]}, expiration: '#{rrsig[:expiration]}', inception: '#{rrsig[:inception]}', key_tag: '#{rrsig[:key_tag]}', signer: '#{rrsig[:signer]}', signature: '#{rrsig[:signature]}'#{ttlclass(rrsig)}\n"
    sprintf("%s%-#{options[:namelength] ||18}s %5i %s %-5s %s %s %s %s %s %s %s ( %s )",
            options[:prefix] || '',
            self[:name], ttlof, classof, 'RRSIG',
            self[:algorithm],
            self[:labels],
            self[:original_ttl],
            self[:expiration],
            self[:inception],
            self[:key_tag],
            self[:signer],
            self[:signature])
  end

end

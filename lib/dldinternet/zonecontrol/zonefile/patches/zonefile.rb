class Zonefile
  attr_accessor :records
  attr_accessor :soa
  attr_accessor :data
  attr_accessor :origin # global $ORIGIN option
  attr_accessor :ttl # global $TTL option
  attr_accessor :filename

  def name; @origin; end

  def namelength
    records.map{ |_,a|
      a.map{ |x|
        x[:name].length
      }
    }.flatten.max
  end

  def add_record(type, data= {})
    if @@preserve_name then
      @lastname = data[:name] if data[:name].to_s != ''
      data[:name] = @lastname if data[:name].to_s == ''
    end
    type = type.downcase.intern
    if type == :soa
      @soa.merge!(data)
      @soa[:origin] ||= @soa[:name]
      @origin = @soa[:origin]
      @soa.delete(:host)
    elsif type == :txt
      data[:text] ||= data[:host]
      data[:text].gsub!(%r{^['"]?(.*?)['"]?$}, '\1')
      data.delete(:host)
      @records[type] << data
    else
      @records[type] << data
    end
  end

  def nameat(rec); rec[:name].eql?(@origin) ? '@' : rec[:name]; end
  def classof(rec); rec[:class].eql?('IN') ? '' : ", class: '#{rec[:class]}'"; end
  def ttlof(rec); rec[:ttl].to_s.eql?(@soa[:ttl].to_s) ? '' : ", ttl: '#{rec[:ttl]}'"; end
  def ttlclass(rec); "#{ttlof(rec)}#{classof(rec)}"; end

  def dsl

    out =<<-ENDH
#
#  Database file #{@filename || 'unknown'} for #{@origin || 'unknown'} zone.
#	Zone version: #{self.soa[:serial]}
#
defaults ttl: #{self.soa[:ttl]}
zone '#{self.soa[:origin]}'	do
	SOA   '@', primary: #{self.soa[:primary]}, 
             email: #{self.soa[:email]},
				     serial: #{self.soa[:serial]}
             refresh: #{self.soa[:refresh]}
             retry: #{self.soa[:retry]}
             expire: #{self.soa[:expire]}
             minimumTTL: #{self.soa[:minimumTTL]}

  # Zone NS Records
    ENDH
    self.ns.each do |ns|
      out << "  NS    '#{nameat(ns)}', '#{ns[:host]}'#{ttlclass(ns)}\n"
    end
    out << "\n# Zone MX Records\n" unless self.mx.empty?
    self.mx.each do |mx|
      out << "  MX	  '#{nameat(mx)}', '#{mx[:host]}', pri: #{mx[:pri]}#{ttlclass(mx)}\n"
    end

    out << "\n# Zone A Records\n" unless self.a.empty?
    self.a.each do |a|
      out << "  A     '#{a[:name]}',	'#{a[:host]}'#{ttlclass(a)}\n"
    end

    out << "\n# Zone CNAME Records\n" unless self.cname.empty?
    self.cname.each do |cn|
      out << "  CNAME '#{cn[:name]}',	'#{cn[:host]}'#{ttlclass(cn)}\n"
    end

    out << "\n# Zone AAAA Records\n" unless self.a4.empty?
    self.a4.each do |a4|
      out << "  AAAA  '#{a4[:name]}', '#{a4[:host]}'#{ttlclass(a4)}\n"
    end

    out << "\n# Zone TXT Records\n" unless self.txt.empty?
    self.txt.each do |tx|
      out << "  TXT    '#{tx[:name]}', '#{tx[:text]}'#{ttlclass(tx)}\n"
    end

    out << "\n# Zone SRV Records\n" unless self.srv.empty?
    self.srv.each do |srv|
      out << "  SRV    '#{srv[:name]}', '#{srv[:host]}', pri: #{srv[:pri]}, weight: #{srv[:weight]}, port: #{srv[:port]}#{ttlclass(srv)}\n"
    end

    out << "\n# Zone PTR Records\n" unless self.ptr.empty?
    self.ptr.each do |ptr|
      out << "  PTR    '#{ptr[:name]}', '#{ptr[:host]}'#{ttlclass(ptr)}\n"
    end

    out << "\n# Zone DS Records\n" unless self.ds.empty?
    self.ds.each do |ds|
      out << "  DS     '#{ds[:name]}', nil, key_tag: '#{ds[:key_tag]}', algorithm: '#{ds[:algorithm]}', digest_type: '#{ds[:digest_type]}', digest: '#{ds[:digest]}'#{ttlclass(ds)}\n"
    end

    out << "\n# Zone NSEC Records\n" unless self.ds.empty?
    self.nsec.each do |nsec|
      out << "  NSEC   '#{nsec[:name]}', nil, next: '#{nsec[:next]}', types: '#{nsec[:types]}'#{ttlclass(nsec)}\n"
    end

    out << "\n# Zone NSEC3 Records\n" unless self.ds.empty?
    self.nsec3.each do |nsec|
      out << "  NSEC3  '#{nsec[:name]}', nil, algorithm: '#{nsec[:algorithm]}', flags: '#{nsec[:flags]}', iterations: '#{nsec3[:iterations]}', salt: '#{nsec3[:salt]}', next: '#{nsec[:next]}', types: '#{nsec[:types]}'#{ttlclass(nsec)}\n"
    end

    out << "\n# Zone NSEC3PARAM Records\n" unless self.ds.empty?
    self.nsec3param.each do |nsec3param|
      out << "  NSEC3PARAM '#{nsec[:name]}', nil, algorithm: '#{nsec[:algorithm]}', flags: '#{nsec[:flags]}', iterations: '#{nsec3[:iterations]}', salt: '#{nsec3[:salt]}'#{ttlclass(nsec)}\n"
    end

    out << "\n# Zone DNSKEY Records\n" unless self.ds.empty?
    self.dnskey.each do |dnskey|
      out << "  DNSKEY '#{dnskey[:name]}', nil, flag: '#{dnskey[:flag]}', protocol: '#{dnskey[:protocol]}', algorithm: '#{dnskey[:algorithm]}', public_key: '#{dnskey[:public_key]}'#{ttlclass(dnskey)}\n"
    end

    out << "\n# Zone RRSIG Records\n" unless self.ds.empty?
    self.rrsig.each do |rrsig|
      out << "  RRSIG  '#{rrsig[:name]}', nil, type_covered: '#{rrsig[:type_covered]}', algorithm: '#{rrsig[:algorithm]}', labels: '#{rrsig[:labels]}', original_ttl: #{rrsig[:original_ttl]}, expiration: '#{rrsig[:expiration]}', inception: '#{rrsig[:inception]}', key_tag: '#{rrsig[:key_tag]}', signer: '#{rrsig[:signer]}', signature: '#{rrsig[:signature]}'#{ttlclass(rrsig)}\n"
    end

    out << "\n# Zone NAPTR Records\n" unless self.ds.empty?
    self.naptr.each do |naptr|
      out << "  NAPTR  '#{naptr[:name]}', nil, order: '#{naptr[:order]}', preference: '#{naptr[:preference]}', flags: '#{naptr[:flags]}', service: '#{naptr[:service]}', regexp: '#{naptr[:regexp]}', replacement: '#{naptr[:replacement]}'#{ttlclass(naptr)}\n"
    end

    out << "end\n"
    out
  end

  def print(options={})
    options[:namelength] ||= namelength
    out =<<-ENDH
#
#  Database file #{@filename || 'unknown'} for #{@origin || 'unknown'} zone.
#	Zone version: #{self.soa[:serial]}
#
#{sprintf("%-#{options[:namelength] ||18}s %5i IN #{self.soa[:class] || 'SOA'} #{self.soa[:primary]} #{self.soa[:email]} #{self.soa[:serial]} %5i %5i %5i %5i \n", 
          self.soa[:origin], 
          self.soa[:ttl], 
          self.soa[:refresh], 
          self.soa[:retry], 
          self.soa[:expire], 
          self.soa[:minimumTTL])}

# Zone NS Records
    ENDH
    self.ns.each do |ns|
      # out << "  NS    '#{nameat(ns)}', '#{ns[:host]}'#{ttlclass(ns)}\n"
      out << sprintf("%-#{options[:namelength] ||18}s %5i IN %-5s %s\n", ns[:name], ns[:ttl], 'NS', ns[:host])
    end
    out << "\n# Zone MX Records\n" unless self.mx.empty?
    self.mx.each do |mx|
      out << sprintf("%-#{options[:namelength] ||18}s %5i IN %-5s %-5s %s\n", mx[:name], mx[:ttl], 'MX', mx[:pri], mx[:host])
    end

    out << "\n# Zone A Records\n" unless self.a.empty?
    self.a.each do |a|
      out << sprintf("%-#{options[:namelength] ||18}s %5i IN %-5s %s\n", a[:name], a[:ttl], 'A', a[:host])
    end

    out << "\n# Zone CNAME Records\n" unless self.cname.empty?
    self.cname.each do |cn|
      out << sprintf("%-#{options[:namelength] ||18}s %5i IN %-5s %s\n", cn[:name], cn[:ttl], 'A', cn[:host])
    end

    out << "\n# Zone AAAA Records\n" unless self.a4.empty?
    self.a4.each do |a4|
      out << sprintf("%-#{options[:namelength] ||18}s %5i IN %-5s %s\n", a4[:name], a4[:ttl], 'A', a4[:host])
    end

    out << "\n# Zone TXT Records\n" unless self.txt.empty?
    self.txt.each do |tx|
      out << sprintf("%-#{options[:namelength] ||18}s %5i IN %-5s %s\n", tx[:name], tx[:ttl], 'TXT', tx[:text])
    end

    out << "\n# Zone SRV Records\n" unless self.srv.empty?
    self.srv.each do |srv|
      out << "  SRV    '#{srv[:name]}', '#{srv[:host]}', pri: #{srv[:pri]}, weight: #{srv[:weight]}, port: #{srv[:port]}#{ttlclass(srv)}\n"
    end

    out << "\n# Zone PTR Records\n" unless self.ptr.empty?
    self.ptr.each do |ptr|
      out << "  PTR    '#{ptr[:name]}', '#{ptr[:host]}'#{ttlclass(ptr)}\n"
    end

    out << "\n# Zone DS Records\n" unless self.ds.empty?
    self.ds.each do |ds|
      out << "  DS     '#{ds[:name]}', nil, key_tag: '#{ds[:key_tag]}', algorithm: '#{ds[:algorithm]}', digest_type: '#{ds[:digest_type]}', digest: '#{ds[:digest]}'#{ttlclass(ds)}\n"
    end

    out << "\n# Zone NSEC Records\n" unless self.ds.empty?
    self.nsec.each do |nsec|
      out << "  NSEC   '#{nsec[:name]}', nil, next: '#{nsec[:next]}', types: '#{nsec[:types]}'#{ttlclass(nsec)}\n"
    end

    out << "\n# Zone NSEC3 Records\n" unless self.ds.empty?
    self.nsec3.each do |nsec|
      out << "  NSEC3  '#{nsec[:name]}', nil, algorithm: '#{nsec[:algorithm]}', flags: '#{nsec[:flags]}', iterations: '#{nsec3[:iterations]}', salt: '#{nsec3[:salt]}', next: '#{nsec[:next]}', types: '#{nsec[:types]}'#{ttlclass(nsec)}\n"
    end

    out << "\n# Zone NSEC3PARAM Records\n" unless self.ds.empty?
    self.nsec3param.each do |nsec3param|
      out << "  NSEC3PARAM '#{nsec[:name]}', nil, algorithm: '#{nsec[:algorithm]}', flags: '#{nsec[:flags]}', iterations: '#{nsec3[:iterations]}', salt: '#{nsec3[:salt]}'#{ttlclass(nsec)}\n"
    end

    out << "\n# Zone DNSKEY Records\n" unless self.ds.empty?
    self.dnskey.each do |dnskey|
      out << "  DNSKEY '#{dnskey[:name]}', nil, flag: '#{dnskey[:flag]}', protocol: '#{dnskey[:protocol]}', algorithm: '#{dnskey[:algorithm]}', public_key: '#{dnskey[:public_key]}'#{ttlclass(dnskey)}\n"
    end

    out << "\n# Zone RRSIG Records\n" unless self.ds.empty?
    self.rrsig.each do |rrsig|
      out << "  RRSIG  '#{rrsig[:name]}', nil, type_covered: '#{rrsig[:type_covered]}', algorithm: '#{rrsig[:algorithm]}', labels: '#{rrsig[:labels]}', original_ttl: #{rrsig[:original_ttl]}, expiration: '#{rrsig[:expiration]}', inception: '#{rrsig[:inception]}', key_tag: '#{rrsig[:key_tag]}', signer: '#{rrsig[:signer]}', signature: '#{rrsig[:signature]}'#{ttlclass(rrsig)}\n"
    end

    out << "\n# Zone NAPTR Records\n" unless self.ds.empty?
    self.naptr.each do |naptr|
      out << "  NAPTR  '#{naptr[:name]}', nil, order: '#{naptr[:order]}', preference: '#{naptr[:preference]}', flags: '#{naptr[:flags]}', service: '#{naptr[:service]}', regexp: '#{naptr[:regexp]}', replacement: '#{naptr[:replacement]}'#{ttlclass(naptr)}\n"
    end

    out
  end
end
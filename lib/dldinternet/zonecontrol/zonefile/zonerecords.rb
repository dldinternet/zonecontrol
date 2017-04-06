require "dldinternet/zonecontrol/zonefile/zonerecords/zone__record"
require "dldinternet/zonecontrol/zonefile/zonerecords/zone_soa_record"
require "dldinternet/zonecontrol/zonefile/zonerecords/zone_mx_record"
require "dldinternet/zonecontrol/zonefile/zonerecords/zone_txt_record"
require "dldinternet/zonecontrol/zonefile/zonerecords/zone_srv_record"
require "dldinternet/zonecontrol/zonefile/zonerecords/zone_ptr_record"
require "dldinternet/zonecontrol/zonefile/zonerecords/zone_ds_record"
require "dldinternet/zonecontrol/zonefile/zonerecords/zone_dnskey_record"
require "dldinternet/zonecontrol/zonefile/zonerecords/zone_rrsig_record"
require "dldinternet/zonecontrol/zonefile/zonerecords/zone_nsec_record"
require "dldinternet/zonecontrol/zonefile/zonerecords/zone_nsec3_record"
require "dldinternet/zonecontrol/zonefile/zonerecords/zone_nsec3param_record"
require "dldinternet/zonecontrol/zonefile/zonerecords/zone_naptr_record"

%w(A AAAA NS CNAME).each do |type|

  Object.class_eval <<-EOS, __FILE__, __LINE__
  class Zone#{type}Record < ZoneRecord
  end
  EOS

end

# Zonefile::RECORDS
%w{ MX A AAAA NS CNAME TXT PTR SRV SOA DS DNSKEY RRSIG NSEC NSEC3 NSEC3PARAM NAPTR }.each do |type|
  begin
    klass = Class.const_get("Zone#{type.to_s.upcase}Record")
  rescue NameError
    $stderr.write "Zone#{type.to_s.upcase}Record\n" unless klass.is_a?(Class)
  end
end
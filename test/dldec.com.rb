defaults :ttl => 3600

zone 'dldec.com' do
  SOA 'burst.dldec.com.', 'hostmaster.delionsden.com.', serial: '2014060701', refresh: 3600, retry: 300, expire: 3600, ttl: 3600
  A 'dldec.com', '66.197.207.182'
  MX 'dldec.com', 'ASPMX.L.GOOGLE.com.', priority: 10
  MX 'dldec.com', 'ALT1.ASPMX.L.GOOGLE.com.', priority: 20
  MX 'dldec.com', 'ALT2.ASPMX.L.GOOGLE.com.', priority: 20
  MX 'dldec.com', 'ASPMX2.GOOGLEMAIL.com.', priority: 30
  MX 'dldec.com', 'ASPMX3.GOOGLEMAIL.com.', priority: 30
  NS 'dldec.com', 'ns1.thedomainnamesystem.com.'
  NS 'dldec.com', 'ns2.thedomainnamesystem.com.'
  NS 'dldec.com', 'ns3.thedomainnamesystem.com.'
  TXT 'dldec.com', "google-site-verification=nOiMzB2uS6748rq4HUsCHfqrS5o88JVbNpOaAt8vH0c"
  A 'www.dldec.com.', '66.197.207.182'
end

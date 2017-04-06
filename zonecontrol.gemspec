# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dldinternet/zonecontrol/version'

Gem::Specification.new do |gem|
  gem.name          = "zonecontrol"
  gem.version       = DLDInternet::ZoneControl::VERSION
  gem.authors       = ["Christo De Lange"]
  gem.email         = ["github@dldinternet.com"]

  gem.summary       = %q{A DSL for managing DNS through cloud services}
  gem.description   = %q{A DSL and tools for managing DNS through any of the services supported by fog.  Currently, this is Amazon Route 53, bluebox, DNSimple, DNS Made Easy, Linode DNS, Slicehost DNS and Zerigo DNS }
  gem.homepage      = "https://github.com/dldinternet/zonecontrol"
  gem.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if gem.respond_to?(:metadata)
    gem.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  gem.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  gem.bindir        = "exe"
  gem.executables   = gem.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_dependency 'dldinternet-mixlib-thor', '>= 0.3.0'
  gem.add_dependency 'zonefile', '>= 1.0.4'
  gem.add_dependency 'hashie', '>= 0'
  gem.add_dependency 'fog', '>= 0.9.0'
  gem.add_dependency 'fog-digitalocean', '>= 0.4.0'
  gem.add_dependency 'thor', '>= 0.19.4'
  gem.add_dependency 'activesupport', '~> 4.2'

  gem.add_development_dependency "bundler", "~> 1.14"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rspec", "~> 3.0"
end

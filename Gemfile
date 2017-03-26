source 'https://rubygems.org' do

  gem 'roodi'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubycritic', '>= 2.9.2', :require => false
  gem 'flog', '>= 4.4.0', :require => false

  group :development, :test, :integration do
    gem 'heckle', :require => false

    gem 'pry'
    gem 'hoe'

    gem 'rspec'
    gem 'simplecov'
    gem 'guard'
    gem 'guard-rubocop'

    gem 'builder'
    gem 'bundler'
    gem 'rake'
    gem 'rubygems-tasks'

    gem 'dldinternet-mixlib-thor',     :path => '../../ws/gems-ws/dldinternet-mixlib-thor',     :group => :development
    gem 'dldinternet-mixlib-logging',  :path => '../../ws/gems-ws/dldinternet-mixlib-logging',     :group => :development
  end

end

# Specify your gem's dependencies in dldinternet-clouddns.gemspec
gemspec

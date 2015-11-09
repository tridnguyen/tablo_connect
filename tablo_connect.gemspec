$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tablo_connect/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tablo_connect"
  s.version     = TabloConnect::VERSION
  s.authors     = ["Tri Nguyen"]
  s.email       = ["nguyentrid@gmail.com"]
  s.homepage    = "http://adeptcode.net"
  s.summary     = "Tablo User Interface"
  s.description = "Web interface to connect to a tablo device, list and export recordings."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.test_files = Dir['spec/**/*']

  s.add_dependency "rails", "~> 4.2"
  s.add_dependency "nokogiri", "~> 1.5"
  s.add_dependency "rest-client", "~> 1.8"
  s.add_dependency "sass-rails", "~> 5.0"

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "sqlite3", "~> 1.3"
  s.add_development_dependency "rspec", "~> 3.3"
  s.add_development_dependency "rspec-rails", "~> 3.3"
  s.add_development_dependency "database_cleaner", "~> 1.5"
  s.add_development_dependency "factory_girl_rails", "~> 4.5"
  s.add_development_dependency "guard", "~> 2.13"
  s.add_development_dependency "guard-rspec", "~> 4.6"
  s.add_development_dependency "terminal-notifier-guard", "~> 1.6"
  s.add_development_dependency "pry", "~> 0.10"
  s.add_development_dependency "test-unit", "~> 3.1"
end

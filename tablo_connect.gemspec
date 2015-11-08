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

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.test_files = Dir['spec/**/*']

  s.add_dependency "rails", "~> 4.2.4"
  s.add_dependency "nokogiri"
  s.add_dependency "rest-client"
  s.add_dependency "sass-rails"

  s.add_development_dependency "bundler"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "terminal-notifier-guard"
  s.add_development_dependency "pry"
  s.add_development_dependency "test-unit"
end

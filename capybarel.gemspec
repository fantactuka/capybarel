# -*- encoding: utf-8 -*-
require File.expand_path("../lib/capybarel/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Maksim Horbachevsky"]
  gem.email         = %w(fantactuka@gmail.com)
  gem.description   = %q{Capybara element helper}
  gem.summary       = %q{Provides easier way to map elements and search for it}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "capybarel"
  gem.require_paths = %w(lib)
  gem.version       = Capybarel::VERSION

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "capybara"
  gem.add_development_dependency "selenium-webdriver"
end

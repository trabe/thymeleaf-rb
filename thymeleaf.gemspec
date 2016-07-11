# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thymeleaf/version'

Gem::Specification.new do |spec|
  spec.name                  = 'thymeleaf'
  spec.version               = Thymeleaf::VERSION
  spec.platform              = Gem::Platform::RUBY
  spec.required_ruby_version = '~> 2.3.0'

  spec.authors               = ['David Barral Precedo', 'Daniel Vazquez Brañas']
  spec.email                 = ['contact@trabesoluciones.com', 'david.barral@trabesoluciones.com']
  spec.summary               = 'Thymeleaf for Ruby'
  spec.description           = 'Thymeleaf template engine for Ruby'
  spec.homepage              = 'https://trabe.github.io/thymeleaf-rb'
  spec.license               = 'MIT'

  spec.files                 = Dir['thymeleaf.rb', 'lib/thymeleaf/**/*.rb']
  spec.require_paths         = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'nokogiri'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'benchmark-ips', '~> 2.6'
end


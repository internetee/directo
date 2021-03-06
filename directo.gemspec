# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'directo/version'

Gem::Specification.new do |spec|
  spec.name = 'directo'
  spec.version = DirectoApi::VERSION
  spec.author = 'Estonian Internet Foundation'
  spec.email = 'info@internet.ee'
  spec.summary = spec.description
  spec.description = 'A Ruby interface to the Directo (http://directo.ee)'
  spec.homepage = 'https://github.com/internetee/directo'
  spec.license = 'MIT'
  spec.files = %w[LICENSE.md README.md directo.gemspec] + Dir['lib/**/*.rb']
  spec.require_paths = %w[lib]

  spec.add_runtime_dependency 'money', '~> 6.13'
  spec.add_runtime_dependency 'nokogiri', '~> 1.10'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 12.3.3'
  spec.add_development_dependency 'simplecov', '0.17'
  spec.add_development_dependency 'webmock'

  spec.required_ruby_version = '>= 2.6'
end

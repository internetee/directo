if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-lcov'
  
  SimpleCov::Formatter::LcovFormatter.config do |c|
    c.report_with_single_file = true
    c.single_report_path = 'coverage/lcov.info'
  end
  
  SimpleCov.start do
    add_filter '/test/'
    formatter SimpleCov::Formatter::LcovFormatter
  end
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'directo'
require 'minitest/autorun'
require 'webmock/minitest'

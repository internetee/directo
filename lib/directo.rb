require 'money'
require 'nokogiri'
require 'directo/version'
require 'directo/configuration'
require 'directo/customer'
require 'directo/invoice'
require 'directo/invoice/line'
require 'directo/invoice/lines'
require 'directo/serializer'
require 'directo/money'

module Directo
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield configuration
    end
  end
end

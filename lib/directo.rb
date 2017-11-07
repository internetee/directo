require 'money'
require 'directo/version'
require 'directo/configuration'
require 'directo/invoice'
require 'directo/invoice/item'

module Directo
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield configuration
    end
  end
end

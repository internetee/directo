require 'forwardable'

require 'money'
require 'nokogiri'
require 'directo/version'
require 'directo/customer'
require 'directo/invoice'
require 'directo/invoice/line'
require 'directo/invoice/lines'
require 'directo/invoices'
require 'directo/serializer'
require 'directo/money'

module Directo
  class << self
    attr_accessor :api_url
  end
end

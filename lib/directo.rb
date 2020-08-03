require 'forwardable'

require 'money'
require 'nokogiri'
require 'directo/version'
require 'directo/client'
require 'directo/customer'
require 'directo/invoice'
require 'directo/invoice/line'
require 'directo/invoice/lines'
require 'directo/invoices'
require 'directo/serializer'
require 'directo/money'
require 'directo/schema'
require 'directo/schemas/prepayment'
require 'directo/schemas/summary'
require 'directo/schemas/auction'
require 'logger'
module DirectoApi
  Money.rounding_mode = BigDecimal::ROUND_HALF_EVEN
  Money.default_currency = Money::Currency.new('EUR')
  Money.locale_backend = nil

  def self.logger
    @logger ||= if defined?(Rails.logger)
                  Rails.logger
                elsif defined?(Rails.root)
                  ::Logger.new(Rails.root.join('log', 'directo_internal_invoice.log'))
                else
                  ::Logger.new(STDOUT)
                end
  end

  def self.logger=(logger)
    @logger = logger
  end
end

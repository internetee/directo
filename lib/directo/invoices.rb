module Directo
  class Invoices
    def initialize(invoices)
      @invoices = invoices
    end

    def deliver
      uri = URI(Directo.configuration.endpoint)
      Net::HTTP.post_form(uri, put: 1, what: 'invoice', xmldata: 'test')
    end
  end
end

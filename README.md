# Directo

[![Build Status](https://travis-ci.org/internetee/directo.svg?branch=master)](https://travis-ci.org/internetee/directo)
[![Maintainability](https://api.codeclimate.com/v1/badges/c0bcfcf7087381250763/maintainability)](https://codeclimate.com/github/internetee/directo/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/c0bcfcf7087381250763/test_coverage)](https://codeclimate.com/github/internetee/directo/test_coverage)

# Usage
Start by initializing Directo client by
```
@client = Directo::Client.new(api_url, sales_agent, payment_terms)
```

Invoice example
```
inv = @client.invoices.new
cust = Directo::Customer.new
cust.code = 'CUST1'
...

line = inv.lines.new
line.code = 123
...

inv.lines.add(line)
@client.invoices.add(inv)
```

Sending to Directo
```
@client.invoices.deliver
```

## Invoice attributes
    :customer # CustomerCode
    :number # Number
    :date # InvoiceDate
    :currency # Currency
    :language # Language
    :vat_amount # TotalVAT
    :payment_terms # Prefilled with client payment terms
    :sales_agent # Prefilled with client Sales Agent value

## Line attributes
      :seq_no # RN
      :code # ProductID
      :description # ProductName

      # Date.parse('2010-07-05')..Date.parse('2010-07-06')
      attr_accessor :period # StartDate  / EndDate

      :vat_number # VATCode
      :quantity # Quantity
      :unit # Unit
      :price # UnitPriceWoVAT

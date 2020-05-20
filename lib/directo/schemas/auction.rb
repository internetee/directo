module DirectoApi
  class Auction < Schema
    def self.meta_schema
      {
        'date': 'issue_date',
        'transaction_date': 'transaction_date',
        'number': 'number',
        'currency': 'currency',
        'language': 'language',
        'vat_amount': 'vat_amount',
        'total_wo_vat': 'total_wo_vat',
        'destination': 'alpha_two_country_code',
        'vat_reg_no': 'vat_reg_no'
      }
    end

    def self.line_schema
      {
        'code': 'product_id',
        'description': 'description',
        'quantity': 'quantity',
        'price': 'price',
        'unit': 'unit',
      }
    end
  end
end

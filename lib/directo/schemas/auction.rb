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
      }
    end

    def self.line_schema
      {
        'code': 'product_id',
        'description': 'description',
        'quantity': 'quantity',
        'price': 'price',
        'unit': 'unit',
        'vat_number': 'vat_number',
      }
    end
  end
end

module DirectoApi
  class Prepayment < Schema
    def self.meta_schema
      {
        'customer': 'customer_code',
        'date': 'issue_date',
        'transaction_date': 'transaction_date',
        'number': 'number',
        'currency': 'currency',
        'language': 'language',
      }
    end

    def self.line_schema
      {
        'code': 'product_id',
        'description': 'description',
        'quantity': 'quantity',
        'price': 'price',
      }
    end
  end
end

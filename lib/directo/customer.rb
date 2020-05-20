module DirectoApi
  class Customer
    attr_accessor :code
    attr_accessor :name
    attr_accessor :destination
    attr_accessor :vat_reg_no

    def initialize(code: nil, name: nil, destination: nil, vat_reg_no: nil)
      @code = code
      @name = name
      @destination = destination
      @vat_reg_no = vat_reg_no
    end
  end
end

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

    def send_vat_code?
      return true if estonian?
      return false if eu_based? && vat_reg_no_not_empty
      return false unless eu_based?

      true
    end

    def vat_reg_no_not_empty
      !(@vat_reg_no.nil? || @vat_reg_no.empty?)
    end

    def eu_based?
      vat_codes = Invoice.vat_codes
      vat_codes.key?(@destination) && !estonian?
    end

    def estonian?
      @destination == 'EE'
    end
  end
end

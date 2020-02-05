module DirectoApi
  class Customer
    attr_accessor :code
    attr_accessor :name

    def initialize(code: nil, name: nil)
      @code = code
      @name = name
    end
  end
end

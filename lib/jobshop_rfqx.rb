require "jobshop_rfqx/engine"

module JobshopRfqx
  mattr_accessor :customer_class
  
  def self.customer_class
    @@customer_class.constantize
  end
end

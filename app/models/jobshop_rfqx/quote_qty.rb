module JobshopRfqx
  class QuoteQty < ActiveRecord::Base
    
    belongs_to :rfq, :class_name => 'JobshopRfqx::Rfq'
    
    validates :qty, :presence => true,
                    :numericality => {:greater_than => 0, :message => 'qty > 0'}  
  end
end

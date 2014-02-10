module JobshopRfqx
  class QuoteQty < ActiveRecord::Base
    attr_accessible :qty, :rfq_id, :as => :role_new
    attr_accessible :qty, :as => :role_new
    
    belongs_to :rfq, :class_name => 'JobshopRfqx::Rfq'
    
    validates :qty, :presence => true,
                    :numericality => {:greater_than => 0, :message => 'qty > 0'}  
  end
end

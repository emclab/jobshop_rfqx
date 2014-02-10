require 'spec_helper'

module JobshopRfqx
  describe QuoteQty do
    it "should reject nil qty" do
      c = FactoryGirl.build(:jobshop_rfqx_quote_qty, :qty => nil)
      c.should_not be_valid
    end
    
  end
end

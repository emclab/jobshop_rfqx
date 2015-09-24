require 'rails_helper'

module JobshopRfqx
  RSpec.describe QuoteQty, type: :model do
    it "should reject nil qty" do
      c = FactoryGirl.build(:jobshop_rfqx_quote_qty, :qty => nil)
      expect(c).not_to be_valid
    end
    
  end
end

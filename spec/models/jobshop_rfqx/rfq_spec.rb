require 'rails_helper'

module JobshopRfqx
  RSpec.describe Rfq, type: :model do
    it "should be OK" do
      c = FactoryGirl.build(:jobshop_rfqx_rfq)
      expect(c).to be_valid
    end
    
    it "should take nil drawing_num" do
      c = FactoryGirl.build(:jobshop_rfqx_rfq, :drawing_num => nil)
      expect(c).to be_valid
    end
    
    it "should reject same drawing_num with same product_name for same customer" do
      c1 = FactoryGirl.create(:jobshop_rfqx_rfq)
      c = FactoryGirl.build(:jobshop_rfqx_rfq)
      expect(c).not_to be_valid
    end
    
    it "should allow same drawing_num for different customer_id" do
      c1 = FactoryGirl.create(:jobshop_rfqx_rfq)
      c = FactoryGirl.build(:jobshop_rfqx_rfq, :customer_id => c1.customer_id + 1)
      expect(c).to be_valid
    end
    
    it "should allow same drawing_num different product_name" do
      c1 = FactoryGirl.create(:jobshop_rfqx_rfq)
      c = FactoryGirl.build(:jobshop_rfqx_rfq, :product_name => 'c1.customer_id + 1')
      expect(c).to be_valid
    end
    
    it "should reject nil product_name" do
      c = FactoryGirl.build(:jobshop_rfqx_rfq, :product_name => nil)
      expect(c).not_to be_valid
    end

    it "should take nil dimension_unit" do
      c = FactoryGirl.build(:jobshop_rfqx_rfq, :dimension_unit => nil)
      expect(c).to be_valid
    end
  end
end

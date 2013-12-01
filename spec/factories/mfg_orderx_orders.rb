# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mfg_orderx_order, :class => 'MfgOrderx::Order' do
    quote_id 1
    rfq_id 1
    wfid 'ffddfddsfs44'
    order_date "2013-10-16"
    delivery_date "2013-10-16"
    shipping_date "2013-10-16"
    qty 1
    order_requirement "MyText"
    expedite false
    cancelled false
    completed false
    last_updated_by_id 1
    customer_po "MyString"
    sample_required false
    executioner_id 1
  end
end

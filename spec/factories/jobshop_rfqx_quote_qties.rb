# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :jobshop_rfqx_quote_qty, :class => 'JobshopRfqx::QuoteQty' do
    rfq_id 1
    qty 1
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :jobshop_rfqx_rfq, :class => 'JobshopRfqx::Rfq' do
    product_name "MyString"
    drawing_num "MyString"
    tech_spec "MyText"
    tech_note "MyText"
    wfid "MyString"
    last_updated_by_id 1
    customer_id 1
    tech_doc "MyText"
    material_requirement "MyText"
    sales_id 1
    product_wt "9.99"
    qty_for_quote "MyString"
    dimension_unit "MyString"
    est_production_date "2013-10-09"
    void false
  end
end

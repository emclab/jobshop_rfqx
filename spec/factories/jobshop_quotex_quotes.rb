# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :jobshop_quotex_quote, :class => 'JobshopQuotex::Quote' do
    quote_task_id 1
    wfid "MyString"
    last_updated_by_id 1
    qty_quoted 1
    unit "MyString"
    material_wt "9.99"
    material_quoted "MyString"
    material_unit_price "9.99"
    unit_price "9.99"
    material_cost "9.99"
    machining_cost "9.99"
    surface_finish_cost "9.99"
    plating_cost "9.99"
    grinding_cost "9.99"
    heat_treat_cost "9.99"
    packing_cost "9.99"
    insp_cost "9.99"
    mgmt_cost "9.99"
    shipping_cost "9.99"
    misc_cost "9.99"
    profit "9.99"
    tax "9.99"
    tooling_cost 1
    mfg_process_id 1
    quoted_by_id 1
    void false
    note "MyText"
  end
end

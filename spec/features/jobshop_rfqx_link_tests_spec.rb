require 'rails_helper'

RSpec.describe "LinkTests", type: :request do
  describe "GET /jobshop_rfqx_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link',
         'right-span#'         => '2', 
               'left-span#'         => '6', 
               'offset#'         => '2',
               'form-span#'         => '4'
        }
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur], :login => 'thistest', :password => 'password', :password_confirmation => 'password')
      
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'jobshop_rfqx_rfqs', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "JobshopRfqx::Rfq.where(:void => false).order('created_at DESC')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'jobshop_rfqx_rfqs', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'jobshop_rfqx_rfqs', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'jobshop_rfqx_rfqs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'create_rfq', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'jobshop_quotex_quotes', :role_definition_id => @role.id, :rank => 1,
           :sql_code => "JobshopQuotex::Quote.where(:void => false).order('created_at DESC')")
        
      @cust = FactoryGirl.create(:kustomerx_customer) 
      
            
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login'
    end
    
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      qty = FactoryGirl.create(:jobshop_rfqx_quote_qty)
      qty1 = FactoryGirl.create(:jobshop_rfqx_quote_qty, :qty => 10)
      q = FactoryGirl.create(:jobshop_rfqx_rfq, :customer_id => @cust.id, :quote_qties => [qty, qty1])

      visit jobshop_rfqx.rfqs_path
      #save_and_open_page
      expect(page).to have_content('RFQs')
      click_link('Edit')
      fill_in 'rfq_drawing_num', with: 'a new drawing#'
      click_button 'Save'
      visit jobshop_rfqx.rfqs_path
      #save_and_open_page
      expect(page).to have_content('a new drawing#')
      
      #bad data
      click_link('Edit')
      fill_in 'rfq_product_name', with: ''
      fill_in 'rfq_drawing_num', with: 'a bad num'
      click_button 'Save'
      visit jobshop_rfqx.rfqs_path
      expect(page).not_to have_content('a bad num')
      #save_and_open_page
      visit jobshop_rfqx.rfqs_path()
      click_link('New Rfq')
      expect(page).to have_content('New RFQ')
     
      visit jobshop_rfqx.new_rfq_path(customer_id: @cust.id)
      fill_in 'rfq_product_name', with: 'a good name'
      fill_in 'rfq_quote_qties_attributes_0_qty', with: 10
      click_button 'Save'
      visit jobshop_rfqx.rfqs_path
      expect(page).to have_content('a good name')
      #save_and_open_page
      visit jobshop_rfqx.rfqs_path
      visit jobshop_rfqx.new_rfq_path(customer_id: @cust.id)
      fill_in 'rfq_product_name', with: ''
      fill_in 'rfq_drawing_num', with: 'a bad name'
      fill_in 'rfq_quote_qties_attributes_0_qty', with: 10
      click_button 'Save'
      visit jobshop_rfqx.rfqs_path
      expect(page).not_to have_content('a bad name')

      #save_and_open_page
      #bad data
      #save_and_open_page
    end
  end
end

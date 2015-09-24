require 'rails_helper'

module JobshopRfqx
  RSpec.describe RfqsController, type: :controller do
    routes {JobshopRfqx::Engine.routes}
    before(:each) do
      expect(controller).to receive(:require_signin)
      expect(controller).to receive(:require_employee)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
    end
    
    before(:each) do
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      @cust = FactoryGirl.create(:kustomerx_customer) 
      #@q_task1 = FactoryGirl.create(:event_taskx_event_task, :name => 'quote && quote') 
      
      session[:user_role_ids] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id).user_role_ids
    end
    
    render_views
    
    describe "GET 'index'" do
      it "returns all rfqs" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'jobshop_rfqx_rfqs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "JobshopRfqx::Rfq.where(:void => false).order('created_at DESC')")
        session[:user_id] = @u.id
        qty = FactoryGirl.create(:jobshop_rfqx_quote_qty)
        q = FactoryGirl.create(:jobshop_rfqx_rfq, :customer_id => @cust.id + 1, :quote_qties => [qty])
        q1 = FactoryGirl.create(:jobshop_rfqx_rfq, :drawing_num => 'new#', :customer_id => @cust.id, :quote_qties => [qty])
        get 'index'
        expect(assigns(:rfqs)).to match_array( [q, q1])
      end
      
      it "should only return rfqs which belongs to the customer" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'jobshop_rfqx_rfqs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "JobshopRfqx::Rfq.where(:void => false).order('created_at DESC')")
        session[:user_id] = @u.id
        q = FactoryGirl.create(:jobshop_rfqx_rfq, :customer_id => @cust.id + 1)
        q1 = FactoryGirl.create(:jobshop_rfqx_rfq, :customer_id => @cust.id)
        get 'index', { :customer_id => @cust.id}
        expect(assigns(:rfqs)).to match_array( [q1])
      end
    end
  
    describe "GET 'new'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'jobshop_rfqx_rfqs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        get 'new', { :customer_id => @cust.id}
        expect(response).to be_success
      end
    end
  
    describe "GET 'create'" do
      it "returns redirect with success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'jobshop_rfqx_rfqs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        q = FactoryGirl.attributes_for(:jobshop_rfqx_rfq, :customer_id => @cust.id)
        get 'create', { :customer_id => @cust.id, :rfq => q}
        expect(response).to redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render new with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'jobshop_rfqx_rfqs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        q = FactoryGirl.attributes_for(:jobshop_rfqx_rfq, :customer_id => @cust.id, :product_name => nil)
        get 'create', { :customer_id => @cust.id, :rfq => q}
        expect(response).to render_template('new')
      end
    end
  
    describe "GET 'edit'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'jobshop_rfqx_rfqs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        q = FactoryGirl.create(:jobshop_rfqx_rfq, :customer_id => @cust.id)
        get 'edit', { :id => q.id}
        expect(response).to be_success
      end
    end
  
    describe "GET 'update'" do
      it "should redirect successfully" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'jobshop_rfqx_rfqs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        q = FactoryGirl.create(:jobshop_rfqx_rfq, :customer_id => @cust.id)
        get 'update', { :id => q.id, :rfq => {:material_requirement => 'steel 201'}}
        expect(response).to redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'jobshop_rfqx_rfqs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        q = FactoryGirl.create(:jobshop_rfqx_rfq, :customer_id => @cust.id)
        get 'update', { :id => q.id, :rfq => {:product_name => ''}}
        expect(response).to render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'jobshop_rfqx_rfqs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.sales_id == session[:user_id]")
        session[:user_id] = @u.id
        q = FactoryGirl.create(:jobshop_rfqx_rfq, :customer_id => @cust.id, :sales_id => @u.id)
        get 'show', { :id => q.id }
        expect(response).to be_success
      end
    end
  
  end
end

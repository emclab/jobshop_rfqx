require_dependency "jobshop_rfqx/application_controller"

module JobshopRfqx
  class RfqsController < ApplicationController
    before_filter :require_employee
    before_filter :load_customer
    helper_method :return_qty_for_quote
    
    def index
      @title = t('RFQs')
      @rfqs = params[:jobshop_rfqx_rfqs][:model_ar_r]  #returned by check_access_right
      @rfqs = @rfqs.where(:customer_id => @customer.id) if @customer
      @rfqs = @rfqs.page(params[:page]).per_page(@max_pagination) 
      @erb_code = find_config_const('rfq_index_view', 'jobshop_rfqx')
    end
  
    def new
      @title = t('New RFQ')
      @rfq = JobshopRfqx::Rfq.new()
      @rfq.quote_qties.build
      @dim_unit = [t('Metric'),t('Inch')]
      @erb_code = find_config_const('rfq_new_view', 'jobshop_rfqx')
    end
  
    def create
      @rfq = JobshopRfqx::Rfq.new(params[:rfq], :as => :role_new)
      @rfq.last_updated_by_id = session[:user_id]
      if @rfq.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @dim_unit = [t('Metric'),t('Inch')]
        @customer = JobshopRfqx.customer_class.find_by_id(params[:rfq][:customer_id]) if params[:rfq].present? && params[:rfq][:customer_id].present?
        @erb_code = find_config_const('rfq_new_view', 'jobshop_rfqx')
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update RFQ')
      @rfq = JobshopRfqx::Rfq.find_by_id(params[:id])
      @dim_unit = [t('Metric'),t('Inch')]
      @erb_code = find_config_const('rfq_edit_view', 'jobshop_rfqx')
    end
  
    def update
      @rfq = JobshopRfqx::Rfq.find_by_id(params[:id])
      @rfq.last_updated_by_id = session[:user_id]
      if @rfq.update_attributes(params[:rfq], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        @dim_unit = [t('Metric'),t('Inch')]
        @erb_code = find_config_const('rfq_edit_view', 'jobshop_rfqx')
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('RFQ Info')
      @rfq = JobshopRfqx::Rfq.find_by_id(params[:id])
      @erb_code = find_config_const('rfq_show_view', 'jobshop_rfqx')
    end
  
    def copy_last
      @title = t('New RFQ')
      @rfq = JobshopRfqx::Rfq.find_by_id(JobshopRfqx::Rfq.where(:customer_id => @customer.id, :void => false).last.id)
      @erb_code = find_config_const('rfq_copy_last_view', 'jobshop_rfqx')
    end
    
    protected
    def load_customer
      @customer = JobshopRfqx.customer_class.find_by_id(params[:customer_id]) if params[:customer_id].present?
      @customer = JobshopRfqx.customer_class.find_by_id(JobshopRfqx::Rfq.find_by_id(params[:id]).customer_id) if params[:id].present?
    end
    
    def return_qty_for_quote(r)
      str = ''
      JobshopRfqx::QuoteQty.where(:rfq_id => r.id).order('qty').each do |c|
        str += ', ' + c.qty.to_s if str.present?
        str += c.qty.to_s if str.blank?
      end
      str
    end
  end
end

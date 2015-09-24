require_dependency "jobshop_rfqx/application_controller"

module JobshopRfqx
  class RfqsController < ApplicationController
    before_action :require_employee
    before_action :load_record
    helper_method :return_qty_for_quote
    
    def index
      @title = t('RFQs')
      @rfqs = params[:jobshop_rfqx_rfqs][:model_ar_r]  #returned by check_access_right
      @rfqs = @rfqs.where(:customer_id => @customer.id) if @customer
      @rfqs = @rfqs.page(params[:page]).per_page(@max_pagination) 
      @erb_code = find_config_const('rfq_index_view', 'jobshop_rfqx') unless @aux_resource
      @erb_code = find_config_const('rfq__' + @aux_model + '_index_view', 'jobshop_rfqx') if @aux_resource
    end
  
    def new
      @title = t('New RFQ')
      @rfq = JobshopRfqx::Rfq.new()
      @rfq.quote_qties.build
      @rfq.send("build_#{@aux_resource.sub(/.+\//,'').singularize.to_s}") if @aux_resource #such as cob_orderx/cob_infos
      @erb_code = find_config_const('rfq_new_view', 'jobshop_rfqx') unless @aux_resource 
      @erb_code = find_config_const('rfq_' + @aux_model + '_new_view', 'jobshop_rfqx') if @aux_resource  #cob_info_new_view, cob_orderx
      @aux_erb_code = find_config_const(@aux_model + '_new_view', @aux_engine) if @aux_resource  #cob_info_new_view, cob_orderx
      @js_erb_code = find_config_const('rfq_new_js_view', 'jobshop_rfqx')
    end
  
    def create
      @rfq = JobshopRfqx::Rfq.new(new_params)
      @rfq.last_updated_by_id = session[:user_id]
      if params[:rfq][:aux_resource].present?
        aux_model = params[:rfq][:aux_resource].strip.sub(/.+\//,'').singularize.to_s
        if params[:rfq][aux_model.to_sym].present?   #fields presented in views
          aux_obj = @rfq.send("build_#{aux_model}")
          params[:rfq][aux_model.to_sym].each do |k, v|
            aux_obj[k.to_sym] = v if v.present?
          end
        end
      end
      if @rfq.save
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Saved!")
      else
        @customer = JobshopRfqx.customer_class.find_by_id(params[:rfq][:customer_id]) if params[:rfq].present? && params[:rfq][:customer_id].present?
        @erb_code = find_config_const('rfq_new_view', 'jobshop_rfqx') if params[:rfq][:aux_resource].blank? 
        @erb_code = find_config_const('rfq_' + @aux_model + '_new_view', 'jobshop_rfqx') if params[:rfq][:aux_resource].present?  #cob_info_new_view, cob_orderx
        @aux_erb_code = find_config_const(@aux_model + '_new_view', @aux_engine) if params[:rfq][:aux_resource].present?  #cob_info_new_view, cob_orderx
        @js_erb_code = find_config_const('rfq_new_js_view', 'jobshop_rfqx') 
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update RFQ')
      @rfq = JobshopRfqx::Rfq.find_by_id(params[:id])
      @erb_code = find_config_const('rfq_edit_view', 'jobshop_rfqx') unless @aux_resource 
      @erb_code = find_config_const('rfq_' + @aux_model + '_edit_view', 'jobshop_rfqx') if @aux_resource
      @aux_erb_code = find_config_const(@aux_model + '_edit_view', @aux_engine) if @aux_resource  #cob_info_new_view, cob_orderx
      @js_erb_code = find_config_const('rfq_edit_js_view', 'jobshop_rfqx')
    end
  
    def update
      @rfq = JobshopRfqx::Rfq.find_by_id(params[:id])
      @rfq.last_updated_by_id = session[:user_id]
      if @aux_resource
        if params[:rfq][@aux_model.to_sym].present? #aux fields presented in views
          aux_obj = @rfq.send(@aux_model)
          params[:rfq][@aux_model.to_sym].each do |k, v|
            aux_obj[k.to_sym] = v if v.present?
          end
        end
      end
      if @rfq.update_attributes(edit_params)
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Updated!")
      else
        @erb_code = find_config_const('rfq_edit_view', 'jobshop_rfqx') unless @aux_resource
        @erb_code = find_config_const('rfq_' + @aux_model + '_edit_view', 'jobshop_rfqx') if @aux_resource
        @aux_erb_code = find_config_const(@aux_model + '_edit_view', @aux_engine) if @aux_resource  #cob_info_new_view, cob_orderx
        @js_erb_code = find_config_const('rfq_edit_js_view', 'jobshop_rfqx')
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('RFQ Info')
      @rfq = JobshopRfqx::Rfq.find_by_id(params[:id])
      @erb_code = find_config_const('rfq_show_view', 'jobshop_rfqx') unless @aux_resource
      @erb_code = find_config_const('rfq_' + @aux_model + '_show_view', 'jobshop_rfqx') if @aux_resource
      @aux_erb_code = find_config_const(@aux_model + '_show_view', @aux_engine) if @aux_resource
    end
    
    def destroy  
      JobshopRfqx::Rfq.delete(params[:id].to_i)
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Deleted!")
    end
    
    protected
    def load_record
      @dim_unit = [[t('Metric'), 'metric'],[t('Inch'), 'inch']]
      @customer = JobshopRfqx.customer_class.find_by_id(params[:customer_id]) if params[:customer_id].present?
      @customer = JobshopRfqx.customer_class.find_by_id(JobshopRfqx::Rfq.find_by_id(params[:id]).customer_id) if params[:id].present?
      @aux_resource = params[:aux_resource].strip if params[:aux_resource]  #cob_orderx/cob_orders
      @aux_resource = JobshopRfqx::Rfq.find_by_id(params[:id]).aux_resource if params[:id].present? && JobshopRfqx::Rfq.find_by_id(params[:id]).respond_to?(:aux_resource)  
      @aux_engine = @aux_resource.sub(/\/.+/, '') if @aux_resource  
      @aux_model = @aux_resource.sub(/.+\//,'').singularize.to_s if @aux_resource  #cob_info
    end
    
    def return_qty_for_quote(r)
      str = ''
      JobshopRfqx::QuoteQty.where(:rfq_id => r.id).order('qty').each do |c|
        str += ', ' + c.qty.to_s if str.present?
        str += c.qty.to_s if str.blank?
      end
      str
    end
    
    private
    def new_params
      params.require(:rfq).permit(:customer_id, :dimension_unit, :drawing_num, :est_production_date, :last_updated_by_id, :material_requirement, :product_name, 
                    :product_wt, :sales_id, :tech_doc, :note, :tech_spec, :void, :wf_state, :category_id, quote_qties_attributes: [:id, :_destroy, :qty, :unit])
    end
    
    def edit_params
      params.require(:rfq).permit(:customer_id, :dimension_unit, :drawing_num, :est_production_date, :last_updated_by_id, :material_requirement, :product_name, 
                    :product_wt, :sales_id, :tech_doc, :note, :tech_spec, :void, :wf_state, :category_id, quote_qties_attributes: [:id, :_destroy, :qty, :unit])
    end
  end
end

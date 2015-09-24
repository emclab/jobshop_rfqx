module JobshopRfqx
  class Rfq < ActiveRecord::Base
    attr_accessor :sales_noupdate, :customer_name, :void_noupdate, :field_changed, :copy_rfq_id
    
    model_name = Rails.env.test? ? 'cob_orderx/cob_infos' : Authentify::AuthentifyUtility.find_config_const('aux_resource', 'jobshop_rfqx')  #cob_orderx/orders
    model_name.split(',').each do |a|
      has_one a.sub(/.+\//,'').singularize.to_sym, class_name: a.camelize.singularize.to_s, dependent: :destroy, autosave: true
    end if model_name.present?
    belongs_to :customer, :class_name => JobshopRfqx.customer_class.to_s
    belongs_to :sales, :class_name => 'Authentify::User'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    has_many :quote_qties, :class_name => 'JobshopRfqx::QuoteQty'
    accepts_nested_attributes_for :quote_qties, :allow_destroy => true
   
    validates :customer_id, :presence => true,
                            :numericality => {:greater_than => 0}  
    #validates :dimension_unit, :presence => true
    validates :product_name, :presence => true, :uniqueness => {:scope => [:customer_id, :tech_spec], :case_sentitive => false, :message => I18n.t('Duplicate Name!') }
    validates :drawing_num, :uniqueness => {:scope => [:customer_id, :product_name], :case_sentitive => false, :message => I18n.t('Duplicate Drawing Number!')}, :if => 'drawing_num.present?'
    validates :category_id, :numericality => {:greater_than => 0}, :if => 'category_id.present?'
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate', 'jobshop_rfqx_rfqs')
      eval(wf) if wf.present?
    end
    
  end
end

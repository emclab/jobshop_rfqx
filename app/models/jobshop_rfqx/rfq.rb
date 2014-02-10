module JobshopRfqx
  class Rfq < ActiveRecord::Base
    attr_accessor :sales_noupdate, :customer_name, :customer_name_autocomplete
    attr_accessible :customer_id, :dimension_unit, :drawing_num, :est_production_date, :last_updated_by_id, :material_requirement, :product_name, 
                    :product_wt, :sales_id, :tech_doc, :tech_note, :tech_spec, :void, :wfid, :quote_qties_attributes,
                    :customer_name_autocomplete,
                    :as => :role_new
    attr_accessible :customer_id, :dimension_unit, :drawing_num, :est_production_date, :last_updated_by_id, :material_requirement, :product_name, 
                    :product_wt, :sales_id, :tech_doc, :tech_note, :tech_spec, :void, :wfid, :quote_qties_attributes,
                    :sales_noupdate, :customer_name, :customer_name_autocomplete,
                    :as => :role_update
    
    belongs_to :customer, :class_name => JobshopRfqx.customer_class.to_s
    belongs_to :sales, :class_name => 'Authentify::User'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    has_many :quote_qties, :class_name => 'JobshopRfqx::QuoteQty'
    accepts_nested_attributes_for :quote_qties, :allow_destroy => true
   
    validates :customer_id, :presence => true,
                            :numericality => {:greater_than => 0}  
    validates :drawing_num, :product_name, :dimension_unit, :presence => true  
    validates_uniqueness_of :drawing_num, :scope => [:customer_id, :product_name], :case_sentitive => false, :message => I18n.t('Duplicate Drawing Number!')
    
    def customer_name_autocomplete
      self.customer.try(:name)
    end

    def customer_name_autocomplete=(name)
      self.customer = JobshopRfqx.customer_class.find_by_name(name) if name.present?
    end           
  end
end

module JobshopRfqx
  class Rfq < ActiveRecord::Base
    attr_accessor :sales_noupdate, :customer_name
    attr_accessible :customer_id, :dimension_unit, :drawing_num, :est_production_date, :last_updated_by_id, :material_requirement, :product_name, 
                    :product_wt, :qty_for_quote, :sales_id, :tech_doc, :tech_note, :tech_spec, :void, :wfid,
                    :as => :role_new
    attr_accessible :customer_id, :dimension_unit, :drawing_num, :est_production_date, :last_updated_by_id, :material_requirement, :product_name, 
                    :product_wt, :qty_for_quote, :sales_id, :tech_doc, :tech_note, :tech_spec, :void, :wfid,
                    :sales_noupdate, :customer_name,
                    :as => :role_update
    
    belongs_to :customer, :class_name => JobshopRfqx.customer_class.to_s
    belongs_to :sales, :class_name => 'Authentify::User'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
   
    validates :customer_id, :presence => true,
                            :numericality => {:greater_than => 0}  
    validates :drawing_num, :product_name, :qty_for_quote, :dimension_unit, :presence => true  
    validates_uniqueness_of :drawing_num, :scope => [:customer_id, :product_name], :case_sentitive => false, :message => I18n.t('Duplicate Drawing Number!')           
  end
end

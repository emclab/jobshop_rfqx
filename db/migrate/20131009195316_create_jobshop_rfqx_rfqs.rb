class CreateJobshopRfqxRfqs < ActiveRecord::Migration
  def change
    create_table :jobshop_rfqx_rfqs do |t|
      t.string :product_name
      t.string :drawing_num
      t.text :tech_spec
      t.text :note
      t.string :wf_state
      t.integer :last_updated_by_id
      t.integer :customer_id
      t.text :tech_doc
      t.text :material_requirement
      t.integer :sales_id
      t.decimal :product_wt, :precision => 12, :scale => 4
      t.string :dimension_unit
      t.date :est_production_date
      t.boolean :void, :default => false
      t.string :aux_resource
      t.integer :category_id

      t.timestamps
    end
    
    add_index :jobshop_rfqx_rfqs, :customer_id
    add_index :jobshop_rfqx_rfqs, :drawing_num
    add_index :jobshop_rfqx_rfqs, :product_name
    add_index :jobshop_rfqx_rfqs, :sales_id
    add_index :jobshop_rfqx_rfqs, :wf_state
    add_index :jobshop_rfqx_rfqs, :aux_resource
    add_index :jobshop_rfqx_rfqs, :category_id
  end
end

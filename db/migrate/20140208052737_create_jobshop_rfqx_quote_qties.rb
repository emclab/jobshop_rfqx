class CreateJobshopRfqxQuoteQties < ActiveRecord::Migration
  def change
    create_table :jobshop_rfqx_quote_qties do |t|
      t.integer :rfq_id
      t.decimal :qty, :precision => 12, :scale => 4
      t.string :unit

      t.timestamps
    end
    
    add_index :jobshop_rfqx_quote_qties, :rfq_id
  end
end

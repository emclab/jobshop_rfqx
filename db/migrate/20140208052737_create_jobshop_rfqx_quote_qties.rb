class CreateJobshopRfqxQuoteQties < ActiveRecord::Migration
  def change
    create_table :jobshop_rfqx_quote_qties do |t|
      t.integer :rfq_id
      t.integer :qty

      t.timestamps
    end
  end
end

require "jobshop_rfqx/engine"

module JobshopRfqx
  mattr_accessor :customer_class, :quote_index_path, :order_index_path, :mfg_process_index_path, :quote_task_index_path
  
  def self.customer_class
    @@customer_class.constantize
  end
end

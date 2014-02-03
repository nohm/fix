class RemoveInvoiceItemsMoveAppId < ActiveRecord::Migration
  def change
  	remove_column :invoices, :items
  	add_column :types, :appliance_id, :integer
  end
end

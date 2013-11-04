class Addinvoicetoentry < ActiveRecord::Migration
  def change
  	add_column :entries, :invoice_id, :integer
  	remove_column :entries, :sent_date
  end
end

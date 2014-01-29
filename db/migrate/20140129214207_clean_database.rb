class CleanDatabase < ActiveRecord::Migration
  def change
  	remove_column :entries, :company
  	remove_column :invoices, :company
  	drop_table :histories
  end
end

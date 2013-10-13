class Removeinvoicedate < ActiveRecord::Migration
  def up
  	remove_column :invoices, :date
  end

  def down
  	add_column :invoices, :date, :datetime
  end
end

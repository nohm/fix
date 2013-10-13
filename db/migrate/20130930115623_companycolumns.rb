class Companycolumns < ActiveRecord::Migration
  def change
  	add_column :entries, :company, :string
  	add_column :invoices, :company, :string
  end
end

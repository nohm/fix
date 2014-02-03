class ColumnTypeForbidden < ActiveRecord::Migration
  def change
  	remove_column :types, :type
  	add_column :types, :typenum, :string

    remove_column :types, :test_price
    remove_column :types, :repair_price
    remove_column :types, :scrap_price

    add_column :types, :test_price, :decimal, precision: 5, scale: 2
    add_column :types, :repair_price, :decimal, precision: 5, scale: 2
    add_column :types, :scrap_price, :decimal, precision: 5, scale: 2
  end
end

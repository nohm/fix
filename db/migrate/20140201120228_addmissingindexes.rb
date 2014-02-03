class Addmissingindexes < ActiveRecord::Migration
  def change
  	add_index :entries, :invoice_id
  	add_index :entries, :type_id

  	add_index :types, :appliance_id
  end
end

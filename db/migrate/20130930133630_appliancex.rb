class Appliancex < ActiveRecord::Migration
  def change
  	remove_column :entries, :appliance_id
  	add_column :appliances, :entry_id, :integer
  end
end

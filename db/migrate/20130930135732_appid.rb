class Appid < ActiveRecord::Migration
  def change
  	add_column :entries, :appliance_id, :integer
  	remove_column :appliances, :entry_id
  end
end

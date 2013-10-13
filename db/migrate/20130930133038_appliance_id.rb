class ApplianceId < ActiveRecord::Migration
  def change
  	remove_column :entries, :appliance
  	add_column :entries, :appliance_id, :string
  end
end

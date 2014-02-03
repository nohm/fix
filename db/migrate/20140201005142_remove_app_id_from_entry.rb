class RemoveAppIdFromEntry < ActiveRecord::Migration
  def change
  	remove_column :entries, :appliance_id
  end
end

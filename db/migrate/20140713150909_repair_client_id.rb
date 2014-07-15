class RepairClientId < ActiveRecord::Migration
  def change
  	add_column :repairs, :client_id, :integer
    add_index :repairs, :client_id
  end
end

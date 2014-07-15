class RepairStatus < ActiveRecord::Migration
  def change
  	add_column :repairs, :status_id, :integer
  end
end

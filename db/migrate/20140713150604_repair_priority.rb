class RepairPriority < ActiveRecord::Migration
  def change
  	add_column :repairs, :priority, :integer
  end
end

class RemoveIrisCodes < ActiveRecord::Migration
  def change
  	remove_column :repairs, :iris_code
  	remove_column :repairs, :after_repair_iris_code
  end
end

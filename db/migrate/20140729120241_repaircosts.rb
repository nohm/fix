class Repaircosts < ActiveRecord::Migration
  def change
  	add_column :repairs, :costs, :string
  end
end

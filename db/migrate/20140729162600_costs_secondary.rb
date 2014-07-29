class CostsSecondary < ActiveRecord::Migration
  def change
  	add_column :repairs, :costs_secondary, :string
  end
end

class CostsToDecimal < ActiveRecord::Migration
  def change
  	change_column :repairs, :costs, "decimal USING replace(NULLIF(costs,''),',','.')::decimal", precision: 5, scale: 2
    change_column :repairs, :costs_secondary, "decimal USING replace(NULLIF(costs_secondary,''),',','.')::decimal", precision: 5, scale: 2
  end
end

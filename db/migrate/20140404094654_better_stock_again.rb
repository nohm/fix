class BetterStockAgain < ActiveRecord::Migration
  def change
  	drop_table :types_stocks
  	create_table :stocks_types do |t|
      t.belongs_to :types
      t.belongs_to :stocks
    end
  end
end

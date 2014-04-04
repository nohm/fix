class BetterStockAgainAgain < ActiveRecord::Migration
  def change
  	drop_table :stocks_types
  	create_table :stocks_types do |t|
      t.belongs_to :type
      t.belongs_to :stock
    end
  end
end

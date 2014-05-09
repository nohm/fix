class StockTypeToStockApptype < ActiveRecord::Migration
  def change
    rename_table :stocks_types, :stocks_apptypes
    rename_column :stocks_apptypes, :type_id, :apptype_id
  end
end

class RenameJoin < ActiveRecord::Migration
  def change
    rename_table :stocks_apptypes, :apptypes_stocks
  end
end

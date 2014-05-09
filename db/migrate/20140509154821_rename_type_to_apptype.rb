class RenameTypeToApptype < ActiveRecord::Migration
  def change
    rename_table :types, :apptypes
  end 
end

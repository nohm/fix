class TypeToApptype < ActiveRecord::Migration
  def change
  	rename_column :entries, :type_id, :apptype_id
  end
end

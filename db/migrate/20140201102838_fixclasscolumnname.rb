class Fixclasscolumnname < ActiveRecord::Migration
  def change
  	rename_column :entries, :class_id, :classification_id
  end
end

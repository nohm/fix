class Fixclasscolumnnameagain < ActiveRecord::Migration
  def change
  	rename_column :entries, :classification_id, :classifications_id
  end
end

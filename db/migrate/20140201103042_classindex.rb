class Classindex < ActiveRecord::Migration
  def change
  	add_index :entries, :classification_id
  end
end

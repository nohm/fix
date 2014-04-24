class EntryUserIds < ActiveRecord::Migration
  def change
  	add_column :entries, :user_create_id, :integer
  	add_column :entries, :user_edit_id, :integer
  end
end

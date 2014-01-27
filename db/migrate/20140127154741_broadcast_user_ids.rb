class BroadcastUserIds < ActiveRecord::Migration
  def change
  	add_column :broadcasts, :user_ids, :string
  end
end

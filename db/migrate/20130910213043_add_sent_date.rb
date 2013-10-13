class AddSentDate < ActiveRecord::Migration
  def up
  	add_column :entries, :sent_date, :datetime
  end

  def down
  	remove_column :entries, :send_date, :datetime
  end
end

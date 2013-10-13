class Typo < ActiveRecord::Migration
  def up
  	remove_column :attachments, :attachments_file_size
  	add_column :attachments, :attachment_file_size, :string
  end

  def down
  	add_column :attachments, :attachments_file_size
  	remove_column :attachments, :attachment_file_size, :string
  end
end

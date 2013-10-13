class Rename < ActiveRecord::Migration
  def up
  	add_column :attachments, :attach_file_name,    :string
    add_column :attachments, :attach_content_type, :string
    add_column :attachments, :attach_file_size,    :integer
    add_column :attachments, :attach_updated_at,   :datetime
    remove_column :attachments, :attachment_file_name
    remove_column :attachments, :attachment_file_size
    remove_column :attachments, :attachment_content_type
    remove_column :attachments, :attachment_updated_at
  end

  def down
  	remove_column :attachments, :attach_file_name
    remove_column :attachments, :attach_content_type
    remove_column :attachments, :attach_file_size
    remove_column :attachments, :attach_updated_at
    add_column :attachments, :attachment_file_name,    :string
    add_column :attachments, :attachment_file_size,    :string
    add_column :attachments, :attachment_content_type,    :string
    add_column :attachments, :attachment_updated_at,    :string
  end
end

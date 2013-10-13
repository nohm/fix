class RemoveAttachFix < ActiveRecord::Migration
  def up
  	remove_column :entries, :attach_file_name
    remove_column :entries, :attach_content_type
    remove_column :entries, :attach_file_size
    remove_column :entries, :attach_updated_at
  end

  def down
  	add_column :entries, :attach_file_name,    :string
    add_column :entries, :attach_content_type, :string
    add_column :entries, :attach_file_size,    :integer
    add_column :entries, :attach_updated_at,   :datetime
  end
end

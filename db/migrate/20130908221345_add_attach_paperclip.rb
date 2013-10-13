class AddAttachPaperclip < ActiveRecord::Migration
  def self.up
    add_column :entries, :attach_file_name,    :string
    add_column :entries, :attach_content_type, :string
    add_column :entries, :attach_file_size,    :integer
    add_column :entries, :attach_updated_at,   :datetime
  end

  def self.down
    remove_column :entries, :attach_file_name
    remove_column :entries, :attach_content_type
    remove_column :entries, :attach_file_size
    remove_column :entries, :attach_updated_at
  end
end

class Update < ActiveRecord::Migration
  def self.up
    remove_column :entries, :attach_file_name
    remove_column :entries, :attach_content_type
    remove_column :entries, :attach_file_size
    remove_column :entries, :attach_updated_at
    add_attachment :entries, :attach
  end

  def self.down
    remove_attachment :entries, :attach
  end
end

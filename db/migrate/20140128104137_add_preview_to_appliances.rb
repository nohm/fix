class AddPreviewToAppliances < ActiveRecord::Migration
  def change
  	remove_column :appliances, :preview
  	add_column :appliances, :preview_file_name,    :string
    add_column :appliances, :preview_content_type, :string
    add_column :appliances, :preview_file_size,    :integer
    add_column :appliances, :preview_updated_at,   :datetime
  end
end

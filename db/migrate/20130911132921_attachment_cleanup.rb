class AttachmentCleanup < ActiveRecord::Migration
  def self.up
  	remove_column :entries, :attach1_file_name
    remove_column :entries, :attach1_content_type
    remove_column :entries, :attach1_file_size
    remove_column :entries, :attach1_updated_at

    remove_column :entries, :attach2_file_name
    remove_column :entries, :attach2_content_type
    remove_column :entries, :attach2_file_size
    remove_column :entries, :attach2_updated_at

    remove_column :entries, :attach3_file_name
    remove_column :entries, :attach3_content_type
    remove_column :entries, :attach3_file_size
    remove_column :entries, :attach3_updated_at

    remove_column :entries, :attach4_file_name
    remove_column :entries, :attach4_content_type
    remove_column :entries, :attach4_file_size
    remove_column :entries, :attach4_updated_at

    remove_column :entries, :attach5_file_name
    remove_column :entries, :attach5_content_type
    remove_column :entries, :attach5_file_size
    remove_column :entries, :attach5_updated_at

    remove_column :entries, :attach6_file_name
    remove_column :entries, :attach6_content_type
    remove_column :entries, :attach6_file_size
    remove_column :entries, :attach6_updated_at

    remove_column :entries, :attach7_file_name
    remove_column :entries, :attach7_content_type
    remove_column :entries, :attach7_file_size
    remove_column :entries, :attach7_updated_at

    remove_column :entries, :attach8_file_name
    remove_column :entries, :attach8_content_type
    remove_column :entries, :attach8_file_size
    remove_column :entries, :attach8_updated_at

    remove_column :entries, :attach9_file_name
    remove_column :entries, :attach9_content_type
    remove_column :entries, :attach9_file_size
    remove_column :entries, :attach9_updated_at
  end

  def self.down
    add_column :entries, :attach_file_name,    :string
    add_column :entries, :attach_content_type, :string
    add_column :entries, :attach_file_size,    :integer
    add_column :entries, :attach_updated_at,   :datetime

    add_column :entries, :attach1_file_name,    :string
    add_column :entries, :attach1_content_type, :string
    add_column :entries, :attach1_file_size,    :integer
    add_column :entries, :attach1_updated_at,   :datetime

    add_column :entries, :attach2_file_name,    :string
    add_column :entries, :attach2_content_type, :string
    add_column :entries, :attach2_file_size,    :integer
    add_column :entries, :attach2_updated_at,   :datetime

    add_column :entries, :attach3_file_name,    :string
    add_column :entries, :attach3_content_type, :string
    add_column :entries, :attach3_file_size,    :integer
    add_column :entries, :attach3_updated_at,   :datetime

    add_column :entries, :attach4_file_name,    :string
    add_column :entries, :attach4_content_type, :string
    add_column :entries, :attach4_file_size,    :integer
    add_column :entries, :attach4_updated_at,   :datetime

    add_column :entries, :attach5_file_name,    :string
    add_column :entries, :attach5_content_type, :string
    add_column :entries, :attach5_file_size,    :integer
    add_column :entries, :attach5_updated_at,   :datetime

    add_column :entries, :attach6_file_name,    :string
    add_column :entries, :attach6_content_type, :string
    add_column :entries, :attach6_file_size,    :integer
    add_column :entries, :attach6_updated_at,   :datetime

    add_column :entries, :attach7_file_name,    :string
    add_column :entries, :attach7_content_type, :string
    add_column :entries, :attach7_file_size,    :integer
    add_column :entries, :attach7_updated_at,   :datetime

    add_column :entries, :attach8_file_name,    :string
    add_column :entries, :attach8_content_type, :string
    add_column :entries, :attach8_file_size,    :integer
    add_column :entries, :attach8_updated_at,   :datetime

    add_column :entries, :attach9_file_name,    :string
    add_column :entries, :attach9_content_type, :string
    add_column :entries, :attach9_file_size,    :integer
    add_column :entries, :attach9_updated_at,   :datetime
  end
end

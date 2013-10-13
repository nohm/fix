class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :entry, index: true
      t.string :attachment_file_name
      t.string :attachments_file_size
      t.string :attachment_content_type
      t.string :attachment_updated_at

      t.timestamps
    end
  end
end

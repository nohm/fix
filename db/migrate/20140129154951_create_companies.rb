class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :title
      t.string :short

      t.timestamps
    end
    add_column :entries, :company_id, :integer
    add_index :entries, :company_id
  end
end

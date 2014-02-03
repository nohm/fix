class CompanyIdToType < ActiveRecord::Migration
  def change
  	add_column :types, :company_id, :integer
    add_index :types, :company_id
  end
end

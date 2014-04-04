class BestterStock < ActiveRecord::Migration
  def change
  	remove_column :stocks, :type_id
  	add_column :stocks, :company_id, :integer

  	create_table :types_stocks do |t|
      t.belongs_to :types
      t.belongs_to :stocks
    end
  end
end

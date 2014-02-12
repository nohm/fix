class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.integer :type_id
      t.string :name
      t.integer :amount
      t.integer :amount_per_app
      t.integer :minimum
      t.boolean :send_mail

      t.timestamps
    end

    add_index :stocks, :type_id
    add_column :companies, :mail, :string
  end
end

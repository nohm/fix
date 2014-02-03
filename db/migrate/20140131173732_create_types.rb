class CreateTypes < ActiveRecord::Migration
  def change
    create_table :types do |t|
      t.string :brand
      t.string :type

      t.decimal :test_price
      t.decimal :repair_price
      t.decimal :scrap_price

      t.timestamps
    end

    add_column :entries, :type_id, :integer
  end
end

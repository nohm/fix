class CreateRepairs < ActiveRecord::Migration
  def change
    create_table :repairs do |t|
      t.string :serial_number
      t.string :type_number
      t.string :brand

      t.string :date_of_purchase
      t.integer :warranty
      t.integer :sales_receipt

      t.string :accessoires
      t.string :damage

      t.string :location

      t.string :iris_code
      t.string :after_repair_iris_code
      t.string :problem
      t.string :solution

      t.string :method_acquire
      t.string :method_return

      t.string :note

      t.timestamps
    end
  end
end

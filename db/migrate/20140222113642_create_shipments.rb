class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.string :number
      t.string :expectance
      t.integer :company_id

      t.timestamps
    end

    add_column :entries, :shipment_id, :integer
    add_index :entries, :shipment_id
  end
end

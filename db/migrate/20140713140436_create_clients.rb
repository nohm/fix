class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name

      t.string :phone_number
      t.string :mobile_phone_number
      t.string :email_address

      t.string :postal_code
      t.string :house_number
      t.string :street
      t.string :city

      t.timestamps
    end
  end
end

class CreateAppliances < ActiveRecord::Migration
  def change
    create_table :appliances do |t|
      t.string :name
      t.string :abb

      t.timestamps
    end
  end
end

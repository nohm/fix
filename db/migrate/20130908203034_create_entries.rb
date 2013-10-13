class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :number
      t.string :brand
      t.string :typenum
      t.string :serialnum
      t.string :note

      t.timestamps
    end
  end
end

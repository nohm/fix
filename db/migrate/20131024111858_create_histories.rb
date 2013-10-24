class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.integer :entry_id
      t.integer :user_id
      t.string :action

      t.timestamps
    end
  end
end

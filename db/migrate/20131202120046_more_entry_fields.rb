class MoreEntryFields < ActiveRecord::Migration
  def change
  	add_column :entries, :repair, :string
  	add_column :entries, :testera, :string
  	add_column :entries, :testerb, :string
  	add_column :entries, :class_id, :integer

  	create_table :classifications do |t|
      t.string :name

      t.timestamps
    end
  end
end

class MoreEntryFields < ActiveRecord::Migration
  def change
  	add_column :entries, :repair, :string
  	add_column :entries, :testera, :string
  	add_column :entries, :testerb, :string
  	add_column :entries, :class_id, :integer

  	add_column :classifications, :name, :string
  end
end

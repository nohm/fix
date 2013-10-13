class AddEntryFields < ActiveRecord::Migration
    def self.up
    add_column :entries, :name, :string
    add_column :entries, :appliance, :string
    add_column :entries, :defect, :string
    add_column :entries, :ordered, :string
    add_column :entries, :test_ok, :integer
    add_column :entries, :repaired, :integer
    add_column :entries, :ready, :integer
    add_column :entries, :scrap, :integer
    add_column :entries, :accessoires, :integer
  end

  def self.down
    remove_column :entries, :name, :string
    remove_column :entries, :appliance, :string
    remove_column :entries, :defect, :string
    remove_column :entries, :ordered, :string
    remove_column :entries, :test_ok, :integer
    remove_column :entries, :repaired, :integer
    remove_column :entries, :ready, :integer
    remove_column :entries, :scrap, :integer
    remove_column :entries, :accessoires, :integer
  end
end

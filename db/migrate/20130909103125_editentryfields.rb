class Editentryfields < ActiveRecord::Migration
  def self.up
    add_column :entries, :test, :integer
    add_column :entries, :sent, :integer
    remove_column :entries, :test_ok, :integer
  end

  def self.down
    remove_column :entries, :test, :integer
    remove_column :entries, :sent, :integer
    add_column :entries, :test_ok, :integer
  end
end

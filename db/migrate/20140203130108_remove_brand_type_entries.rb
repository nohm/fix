class RemoveBrandTypeEntries < ActiveRecord::Migration
  def change
  	remove_column :entries, :brand
  	remove_column :entries, :typenum
  end
end

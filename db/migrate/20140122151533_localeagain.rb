class Localeagain < ActiveRecord::Migration
  def change
  	remove_column :users, :locale
  	add_column :users, :locale, :string
  end
end

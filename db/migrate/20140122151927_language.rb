class Language < ActiveRecord::Migration
  def change
  	remove_column :users, :locale
  	add_column :users, :language, :string, :default => "en"
  end
end

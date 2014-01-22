class Userlocale < ActiveRecord::Migration
  def change
  	add_column :users, :locale, :string, :null => false, :default => "en"
  end
end
